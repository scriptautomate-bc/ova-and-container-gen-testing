#!/bin/bash
set -e

echo "Starting installation..."
# Install required packages
tdnf install -y git tar jq rpm

# 1. Setup Salt RPM Repository
echo "Configuring Salt repository..."
curl -fsSL https://github.com/saltstack/salt-install-guide/releases/latest/download/salt.repo | tee /etc/yum.repos.d/salt.repo

# 2. Install Salt Master and Minion
tdnf install -y salt-master salt-minion

# Output the installed versions
echo "Installed Salt versions:"
salt-master --version
salt-minion --version

# 3. Setup State Tree and Pillar pre-work
echo "Setting up Salt directory structures..."
mkdir -p /srv/salt /srv/pillar
chown -R salt:salt /srv/salt /srv/pillar

# 4. Configure Minion to target the local Master
echo "Configuring minion..."
mkdir -p /etc/salt/minion.d
echo "master: 127.0.0.1" > /etc/salt/minion.d/master.conf

# 5. Install the saltext-vcf extension via salt-pip
echo "Installing saltext-vcf..."
salt-pip install saltext-vcf

# 6. Enable Services (Conditional for OVA compatibility)
# Containers typically do not use systemctl, so we only enable if the command is available
if command -v systemctl >/dev/null 2>&1; then
    echo "Enabling Salt services for OVA boot..."
    systemctl enable salt-master
    systemctl enable salt-minion
else
    echo "systemctl not found (expected in container builds). Skipping service enablement."
fi

echo "Installation complete."
