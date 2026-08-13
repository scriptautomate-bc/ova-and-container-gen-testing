#!/bin/bash
# Container has no init system, so this entrypoint (PID 1) is what stands in for
# the OVA's salt-firstboot systemd unit: it starts the daemons and runs the same
# key-verify-and-accept script on every container start, then stays in the
# foreground so the container keeps running.
set -euo pipefail

mkdir -p /var/log/salt
salt-master -d
salt-minion -d

/usr/local/sbin/salt-firstboot.sh || echo "salt-firstboot: continuing despite failure" >&2

exec tail -F /var/log/salt/master /var/log/salt/minion
