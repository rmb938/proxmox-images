#!/bin/bash

set -exuo pipefail

systemctl start consul-template-prometheus.service
systemctl start consul-template-grafana-pdc.service
