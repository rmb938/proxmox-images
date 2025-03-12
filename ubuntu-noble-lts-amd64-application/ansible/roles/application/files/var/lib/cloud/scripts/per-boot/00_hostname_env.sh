#!/bin/bash

set -o pipefail
set -e
set -x

systemctl set-environment HOSTNAME=$(hostname -f)
