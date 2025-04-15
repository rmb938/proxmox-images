#!/bin/bash

set -exuo pipefail

mount.nfs 192.168.27.40:/mnt/tank-ssd/vms/images /var/lib/glance/images -o sync,noacl,noatime,nodiratime,noac,vers=4.2