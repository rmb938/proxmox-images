#!/bin/bash

set -o pipefail
set -e
set -x

systemctl start consul-template-prometheus.service
systemctl start consul-template-grafana-pdc.service
