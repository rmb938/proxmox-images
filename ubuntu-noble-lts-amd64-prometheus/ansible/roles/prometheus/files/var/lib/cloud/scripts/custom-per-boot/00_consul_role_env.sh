#!/bin/bash

set -exuo pipefail

systemctl set-environment CONSUL_ROLE=prometheus
