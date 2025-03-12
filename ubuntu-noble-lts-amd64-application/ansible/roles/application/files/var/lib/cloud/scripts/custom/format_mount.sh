#!/bin/bash

set -exuo pipefail

# vars
vgName=vg_data

blockDevice=${BLOCK_DEVICE}
lvName=${LV_NAME:-'lv_data'}
lvSize=${LV_SIZE:-'100%FREE'}
mountLocation="${MOUNT_LOCATION}"
mountLocationOwner="${MOUNT_OWNER}"

# Check if block device exists
if [ ! -b "$blockDevice" ]; then
  echo "Did not find block device at location ${blockDevice}"
  exit 1
fi

# Check if we need to create the pv
set +e
pvcreate ${blockDevice} -t
pvcreatetest=$?
set -e

if [ $pvcreatetest -eq 0 ]; then
  echo "PV is not created, create it"
  pvcreate ${blockDevice}
fi

# Check if we need to create the vg
set +e
vgcreate ${vgName} ${blockDevice} -t
vgcreatetest=$?
set -e

if [ $vgcreatetest -eq 0 ]; then
  echo "VG is not created, create it"
  vgcreate ${vgName} ${blockDevice}
fi

# Check if we need to create the lv
set +e
lvcreate -l ${lvSize} -n ${lvName} ${vgName} -t
lvcreatetest=$?
set -e

if [ $lvcreatetest -eq 0 ]; then
  echo "LV is not created, create it"
  lvcreate -l ${lvSize} -n ${lvName} ${vgName}
fi

# Check if we need to format the drive
set +e
blkid -t TYPE=xfs /dev/${vgName}/${lvName}
formatDriveTest=$?
set -e

if [ $formatDriveTest -ne 0 ]; then
  echo "LV is not formatted, format it"
  mkfs.xfs -f /dev/${vgName}/${lvName}
fi

# Mount the drive
mount /dev/${vgName}/${lvName} ${mountLocation}

# Chown mount
chmod 0755 ${mountLocation}
chown ${mountLocationOwner}:${mountLocationOwner} ${mountLocation}
