#!/bin/bash

set -exuo pipefail

set -a
source /etc/cloud-environment
set +a

if [[ ! -v CONSUL_ROLE ]]; then
  echo "CONSUL_ROLE is not set, not starting consul-template services"
  exit 1
fi

if [[ ! -f "/run/custom-per-boot-success" ]]; then
  echo "Custom Per Boot scripts where not successful, not starting consul-template services"
  exit 1
fi

for service_file in /etc/systemd/system/consul-template-*.service; do
  # Extract the service name from the file path
  service_name=$(basename "$service_file" | sed 's/\.service$//')

  # Start the service
  sudo systemctl start "$service_name"

  # Check if the service started successfully (optional)
  if [ $? -eq 0 ]; then
    echo "Started service: $service_name"
  else
    echo "Failed to start service: $service_name"
  fi
done
