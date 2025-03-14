#!/bin/bash

set -exuo pipefail

export BLOCK_DEVICE="/dev/disk/by-id/scsi-0QEMU_QEMU_HARDDISK_drive-scsi1"
export MOUNT_LOCATION="/var/lib/postgresql"
export MOUNT_OWNER="postgres"
/var/lib/cloud/scripts/custom/format_mount.sh

mkdir -p /var/lib/postgresql/17/patroni
chown postgres:postgres /var/lib/postgresql/17
chown postgres:postgres /var/lib/postgresql/17/patroni
chmod 0700 /var/lib/postgresql/17
chmod 0700 /var/lib/postgresql/17/patroni