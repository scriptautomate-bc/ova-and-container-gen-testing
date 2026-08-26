Check certificates for fleet elements:
  module.run:
    - name: vcf_vcfops_fleet_certificates.list_
    - appliance: "VCF_AUTOMATION"
    - status: "NORMAL"
    
Check expiry passwords for any element:
  module.run:
    - name: vcf_vcfops_fleet_certificates.check_expiry
    - threshold_days: 10
    - appliance: "VCF_AUTOMATION"
