Check passwords for fleet elements:
  module.run:
    - name: vcf_vcfops_fleet_passwords.list_
    - appliance: "VCENTER"
    - status: "ACTIVE"
    
Check expiry passwords for any element:
  module.run:
    - name: vcf_vcfops_fleet_passwords.check_expiry
    - expiry_days: 90
    - appliance: "VCF_AUTOMATION"

Get NSXM audit users passwords:
  module.run:
    - name: vcf_vcfops_fleet_passwords.list_
    - appliance: "NSXT_EDGE"
    - username: "admin"
