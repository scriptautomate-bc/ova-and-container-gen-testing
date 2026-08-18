#!/bin/bash
# Generates/accepts the local minion's key on first boot of an instance, verifying
# by direct file comparison that the key being accepted is the one this minion
# process itself wrote to disk (not some other minion racing to register under
# the same ID). Safe to re-run: no-ops once the minion is already accepted.
set -euo pipefail

MINION_ID="$(cat /etc/salt/minion_id 2>/dev/null || hostname)"
LOCAL_PUBKEY="/etc/salt/pki/minion/minion.pub"
MASTER_ACCEPTED="/etc/salt/pki/master/minions/${MINION_ID}"
MASTER_PENDING="/etc/salt/pki/master/minions_pre/${MINION_ID}"

# First check: If the accepted key exists, compare its contents directly
if [ -f "$MASTER_ACCEPTED" ] && [ "$(cat "$LOCAL_PUBKEY" 2>/dev/null)" = "$(cat "$MASTER_ACCEPTED" 2>/dev/null)" ]; then
    echo "salt-firstboot: ${MINION_ID} already accepted, verifying connectivity only"
else
    # Wait for the minion to generate its own keypair
    for i in $(seq 1 30); do
        [ -f "$LOCAL_PUBKEY" ] && break
        sleep 1
    done
    if [ ! -f "$LOCAL_PUBKEY" ]; then
        echo "salt-firstboot: minion never generated a keypair, aborting" >&2
        exit 1
    fi

    # Wait for that same key to show up as pending on the master
    for i in $(seq 1 30); do
        [ -f "$MASTER_PENDING" ] && break
        sleep 1
    done
    if [ ! -f "$MASTER_PENDING" ]; then
        echo "salt-firstboot: no pending key for ${MINION_ID} on master, aborting" >&2
        exit 1
    fi

    # The critical check: only accept if the pending key's bytes are IDENTICAL to
    # the key this specific minion process generated locally. Anything else
    # (a different minion racing to register under the same ID) is refused.
    if [ "$(cat "$LOCAL_PUBKEY")" != "$(cat "$MASTER_PENDING")" ]; then
        echo "salt-firstboot: pending key for ${MINION_ID} does not match local minion's own key, refusing to accept" >&2
        exit 1
    fi

    salt-key --accept="${MINION_ID}" --yes
    echo "salt-firstboot: accepted verified key for ${MINION_ID}"
fi

for i in $(seq 1 15); do
    if salt "${MINION_ID}" test.ping --timeout=5 2>/dev/null | grep -q 'True'; then
        echo "salt-firstboot: ${MINION_ID} responded to test.ping"
        exit 0
    fi
    sleep 2
done

echo "salt-firstboot: ${MINION_ID} did not respond to test.ping in time" >&2
exit 1
