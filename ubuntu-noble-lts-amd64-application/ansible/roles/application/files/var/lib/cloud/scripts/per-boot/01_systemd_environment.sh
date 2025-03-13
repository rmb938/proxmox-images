#!/bin/bash

set -exuo pipefail

while IFS= read -r line; do
  # Skip empty lines and lines starting with '#' (comments)
  if [[ -n "$line" && ! "$line" =~ ^# ]]; then
    # Example: Split the line into key and value
    if [[ "$line" =~ ^([^=]+)=(.*)$ ]]; then
      key="${BASH_REMATCH[1]}"
      value="${BASH_REMATCH[2]}"

      systemctl set-environment "${key}=${value}"
    else
        echo "Warning: Line does not match key=value format: $line"
    fi

  fi
done < "/etc/cloud-environment"
