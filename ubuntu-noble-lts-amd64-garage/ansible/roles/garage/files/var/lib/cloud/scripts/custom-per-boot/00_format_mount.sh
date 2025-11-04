#!/bin/bash

set -exuo pipefail

export BLOCK_DEVICE="/dev/disk/by-id/scsi-0QEMU_QEMU_HARDDISK_drive-scsi1"
export MOUNT_LOCATION="/var/lib/garage"
export MOUNT_OWNER="garage"
/var/lib/cloud/scripts/custom/format_mount.sh
