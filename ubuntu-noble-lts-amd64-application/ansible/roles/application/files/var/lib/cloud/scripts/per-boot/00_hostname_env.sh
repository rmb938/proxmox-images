#!/bin/bash

set -exuo pipefail

systemctl set-environment HOSTNAME=$(hostname -f)
systemctl set-environment CONSUL_HOSTNAME=$(hostname).node.consul