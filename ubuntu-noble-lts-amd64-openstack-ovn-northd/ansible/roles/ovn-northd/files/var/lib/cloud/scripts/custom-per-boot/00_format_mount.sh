#!/bin/bash

set -exuo pipefail

export BLOCK_DEVICE="/dev/disk/by-id/scsi-0QEMU_QEMU_HARDDISK_drive-scsi1"
export MOUNT_LOCATION="/var/lib/ovn"
export MOUNT_OWNER="root"
/var/lib/cloud/scripts/custom/format_mount.sh
