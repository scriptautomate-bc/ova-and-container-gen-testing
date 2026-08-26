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

# Profiles are used in conjunction with NTP state.
# It only requires the vcenter settings, unless working with an ESXi host not attached to a vCenter.
  profiles:
    myesxi_1.host:
      esxi:
        host: myesxi_1.host
        username: root
        password: mypassword
        verify_ssl: False
      vcenter:
        host: myesxi_1.host
        username: root
        password: mypassword
        verify_ssl: False
    myesxi_2.host:
      esxi:
        host: myesxi_2.host
        username: root
        password: mypassword
        verify_ssl: False
      vcenter:
        host: myesxi_2.host
        username: root
        password: mypassword
        verify_ssl: False