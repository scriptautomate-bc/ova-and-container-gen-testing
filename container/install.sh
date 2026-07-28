#!/bin/bash
set -e

echo "Starting installation..."

# Update the package index and upgrade existing packages
tdnf update -y

# Install required packages
tdnf install -y git tar jq

# 1. Setup Salt RPM Repository (Substituting standard dnf instructions for tdnf)
echo "Configuring Salt 3008.x repository..."
rpm --import https://repo.saltproject.io/salt/py3/redhat/9/x86_64/SALT-PROJECT-GPG-PUBKEY-2023.pub
curl -fsSL https://repo.saltproject.io/salt/py3/redhat/9/x86_64/3008.repo | tee /etc/yum.repos.d/salt.repo

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

# 6. Accept Keys and Test Connection
# We start the daemons in the background so this works within Docker and chroot builds
echo "Starting daemons temporarily for key generation and acceptance..."
/usr/bin/salt-master -d
/usr/bin/salt-minion -d

# Wait for the minion to spin up, generate keys, and check in with the master
sleep 15

# Accept the key
echo "Accepting unaccepted keys..."
salt-key -L
salt-key -A -y

# Validate connection
echo "Testing minion connection..."
salt '*' test.ping

# Terminate background daemons so the build step exits cleanly
pkill salt-minion || true
pkill salt-master || true

# 7. Enable Services (Conditional for OVA compatibility)
# Containers typically do not use systemctl, so we only enable if the command is available
if command -v systemctl >/dev/null 2>&1; then
    echo "Enabling Salt services for OVA boot..."
    systemctl enable salt-master
    systemctl enable salt-minion
else
    echo "systemctl not found (expected in container builds). Skipping service enablement."
fi

echo "Installation complete."
