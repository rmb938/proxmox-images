#!/bin/bash

set -o pipefail
set -e

directory="/var/lib/cloud/scripts/custom-per-boot"

if [[ ! -d "$directory" ]]; then
  echo "Error: Directory '$directory' not found."
  exit 1
fi

for file in "$directory"/*; do
  if [[ -f "$file" ]]; then
    if [[ -x "$file" ]]; then
      echo "Executing: $file"
      "$file"
    else
      echo "Skipping (not executable): $file"
    fi
  else
    echo "Skipping (not a regular file): $file"
  fi
done

echo "Finished processing files in $directory."