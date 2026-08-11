list_vc_users:
  module.run:
    - vcf_vcfops_fleet_passwords.list_:
      - appliance: VCENTER

listi_sddcm_users:
  module.run:
    - vcf_vcfops_fleet_passwords.list_:
      - appliance: SDDC_MANAGER

list_nsxm_users:
  module.run:
    - vcf_vcfops_fleet_passwords.list_:
      - appliance: NSXT_MANAGER

list_nsxedge_users:
  module.run:
    - vcf_vcfops_fleet_passwords.list_:
      - appliance: NSXT_EDGE

list_ops_users:
  module.run:
    - vcf_vcfops_fleet_passwords.list_:
      - appliance: VCF_OPERATIONS

#list_vra_users:
#  module.run:
#    - vcf_vcfops_fleet_passwords.list_:
#      - appliance: VCF_AUTOMATION

#list_vrslcm_users:
#  module.run:
#    - vcf_vcfops_fleet_passwords.list_:
#      - appliance: VRSLCM
