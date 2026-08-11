check_fleet_password_expiration:
  module.run:
    - vcf_vcfops_fleet_passwords.check_expiry:
      - threshold_days: 90
