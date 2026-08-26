{% set profiles = salt['pillar.get']('saltext.vcf:profiles', {}) %}
{% for host in profiles %}
ntp_full_{{ host }}:
  vcf_vim_host_config.ntp:
    - name: Configure NTP on {{ host }}
      host: {{ host }}
      servers:
        - us.pool.ntp.org
        - 10.3.0.10
      running: True
      profile: {{ host }}
{% endfor %}
