{#
  Check VCF fleet certificate expiry and collect expiring/expired cert IDs.

  Pillar overrides (all optional):
    vcf_cert_threshold_days   expiry window in days        (default: 90)
    vcf_cert_appliance        limit to one appliance type  (default: all)
    vcf_cert_appliance_fqdn   limit to one appliance FQDN (default: all)
    vcf_cert_category         limit to one cert category   (default: all)
    vcf_cert_ca_type          OPENSSL or MSCA              (default: OPENSSL)

  Usage:

    salt 'salt-master04' state.apply vcf.certs.renew_certs
    salt 'salt-master04' state.apply vcf.certs.renew_certs \
      pillar='{"vcf_cert_appliance": "VCENTER", "vcf_cert_threshold_days": 30}'
#}

{%- set threshold_days = pillar.get('vcf_cert_threshold_days', 90)   %}
{%- set appliance      = pillar.get('vcf_cert_appliance',      None)  %}
{%- set appliance_fqdn = pillar.get('vcf_cert_appliance_fqdn', None)  %}
{%- set category       = pillar.get('vcf_cert_category',       None)  %}
{%- set ca_type        = pillar.get('vcf_cert_ca_type',        'VMCA') %}

{# ── Call check_expiry at render time so results can drive states below ── #}
{%- set expiry = salt['vcf_vcfops_fleet_certificates.check_expiry'](
      threshold_days=threshold_days,
      appliance=appliance,
      appliance_fqdn=appliance_fqdn,
      category=category
) %}

{%- set expiring_certs = expiry.get('expiring', []) %}
{%- set expiring_ids   = expiring_certs | map(attribute='certificateResourceKey') | list %}

# ── Report ────────────────────────────────────────────────────────────────────

Report certificate expiry status:
  test.show_notification:
    - text: |
        Threshold  : {{ threshold_days }} days
        Checked    : {{ expiry.get('totalCount', 0) }}
        OK         : {{ expiry.get('okCount', 0) }}
        Expiring   : {{ expiry.get('expiringCount', 0) }}
        No expiry  : {{ expiry.get('noExpiryCount', 0) }}
{%- if expiring_certs %}
        IDs to renew:
{%- for cert in expiring_certs %}
          - {{ cert.certificateResourceKey }} ({{ cert.get('applianceFqdn', 'unknown') }}, {{ cert.get('daysUntilExpiry', '?') }} days)
{%- endfor %}
{%- endif %}

# ── Replace each expiring / expired certificate ───────────────────────────────

{%- if expiring_ids %}

{%- for cert in expiring_certs %}
{%- set key  = cert.certificateResourceKey %}
{%- set fqdn = cert.get('applianceFqdn', key) %}

Replace certificate for {{ fqdn }}:
  module.run:
    - name: vcf_vcfops_fleet_certificates.replace
    - certificate_resource_key: "{{ key }}"
    - ca_type: "{{ ca_type }}"

{%- endfor %}

{%- else %}

No certificates require renewal:
  test.succeed_without_changes:
    - name: "All {{ expiry.get('totalCount', 0) }} certificates are within the {{ threshold_days }}-day threshold"

{%- endif %}


