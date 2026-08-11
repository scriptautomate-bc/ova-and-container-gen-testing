# This is an example of a pillar file that contains VCF appliance credentials.
saltext.vcf:
  vcenter:
    host: vc-mgmt-a.site-a.vcf.lab
    username: administrator@vsphere.local
    password: mypassword
    verify_ssl: false
  sddc_manager:
    host: sddcmanager-a.site-a.vcf.lab
    username: administrator@vsphere.local
    password: mypassword
    verify_ssl: false
  nsx:
    host: nsx-mgmt-01a.site-a.vcf.lab
    username: admin
    password: mypassword
    verify_ssl: false
  vcf_ops:
    host: ops-a.site-a.vcf.lab
    username: admin
    password: mypassword
    verify_ssl: false
