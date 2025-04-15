#!/bin/bash

set -exuo pipefail

host_octal=$(ip -o -4 addr show eth0 | awk '{print $4}' | rev | cut -d'.' -f1 | rev)
ip addr add 192.168.27.${host_octal} dev enp1s0
ip link set enp1s0 up