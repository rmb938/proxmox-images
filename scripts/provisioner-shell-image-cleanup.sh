#!/bin/bash

set -exuo pipefail

# Cleaning apt since we no longer need it's caches.
sudo apt clean

# Need to reset cloud-init and machine id things.
# If we don't do this things like DHCP will hand 
# out the same IPs to multiple VMs.
sudo cloud-init --debug clean --logs --configs all

# And truncate machine-id since cloud-init does it weirdly.
sudo truncate -s 0 /etc/machine-id /var/lib/dbus/machine-id

# No longer packer.
sudo rm /var/tmp/packer