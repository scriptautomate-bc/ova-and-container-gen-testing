# This is an example of a pillar file that contains VCF appliance credentials.
# Please note that this ova and the Salt components have been specifically designed to use the usernames outlined in these sample credential files. They may not work with other usernames.
saltext.vcf:
  vcenter:
    host: myfqdn.myorg.com
    username: administrator@vsphere.local
    password: mypassword
    verify_ssl: false
  sddc_manager:
    host: myfqdn.myorg.com
    username: administrator@vsphere.local
    password: mypassword
    verify_ssl: false
  nsx:
    host: myfqdn.myorg.com
    username: admin
    password: mypassword
    verify_ssl: false
  vcf_ops:
    host: myfqdn.myorg.com
    username: admin
    password: mypassword
    verify_ssl: false
