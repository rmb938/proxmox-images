#!/bin/bash

set -exuo pipefail

systemctl set-environment HOSTNAME=$(hostname -f)
