#!/bin/bash

set -euo pipefail

image_path=$1

build_timestamp=$(date --iso-8601='seconds')
build_unix=$(date -d ${build_timestamp} +"%s")

output_family=$(basename ${image_path})

export PKR_VAR_proxmox_hostname="freenas-pm.rmb938.me"
export PKR_VAR_proxmox_username="root@pam!test"
export PKR_VAR_proxmox_token="2fffdfda-b6db-49e3-b376-ac1fe7384eee"

# Find the base images
image_family=$(cat ${image_path}/base-image-family)
echo "Looking for VM Template Image with family ${image_family}"
raw_resources=$(curl -s https://${PKR_VAR_proxmox_hostname}:8006/api2/json/cluster/resources?type=vm -H "Authorization: PVEAPIToken=${PKR_VAR_proxmox_username}=${PKR_VAR_proxmox_token}")
qemu_templates=$(echo ${raw_resources} | jq '.data[] | select(.type == "qemu" and .template == 1)')
image_family_templates=$(echo ${qemu_templates} | jq '. | select(.tags // "" | split(";") | any(. == "image") and any(. == "family-'${image_family}'"))')
image_family_templates_length=$(echo "${image_family_templates}" | jq -s '. | length')

if [[ "$image_family_templates_length" -eq 0 ]]; then
  echo "Did not find any VM Template images with family ${image_family}"
  exit 1
fi

echo "Found the following VM Templates for family ${image_family}:"

echo ${image_family_templates} | jq -s -r '(["NAME","ID"] | (., map(length*"-"))), (.[] | [.name, .id]) | @tsv' | column -ts $'\t'
echo ""

# Find the lasted image in the base images
echo "Finding Latest Image in Family ${image_family}"
latest_image_raw=$(echo ${image_family_templates} | jq -s -r '.[] | select(.tags | split(";") | any(contains("latest")))')
latest_image_length=$(echo "${latest_image_raw}" | jq -s '. | length')

if [[ "$latest_image_length" -eq 0 ]]; then
  echo "Did not find any latest images, printing images in family"
  echo ${image_family_templates} | jq
  exit 1
elif [[ "$latest_image_length" -gt 1 ]]; then
  echo "Found multiple latest images, we are in a bad state, printing latest images"
  echo ${latest_image_raw} | jq
  exit 1
fi

echo "Found latest Image in Family ${image_family}: $(echo ${latest_image_raw} | jq '"\(.name) - \(.id)"')"

export PKR_VAR_clone_vm_id=$(echo ${latest_image_raw} | jq -r '.id | sub("^qemu/"; "")')

# Build the new image
(cd ${image_path} && packer build -force -timestamp-ui main.pkr.hcl)

# TODO: during PRs we need the option to not continue and delete the created vm
#   since we don't want PRs to tag the VM as latest or add it to the family

# Remove latest tag from previously built images
echo "Removing latest tag from previously built images"
raw_resources=$(curl -s https://${PKR_VAR_proxmox_hostname}:8006/api2/json/cluster/resources?type=vm -H "Authorization: PVEAPIToken=${PKR_VAR_proxmox_username}=${PKR_VAR_proxmox_token}")
qemu_templates=$(echo ${raw_resources} | jq '.data[] | select(.type == "qemu" and .template == 1)')
image_family_templates=$(echo ${qemu_templates} | jq '. | select(.tags // "" | split(";") | any(. == "image") and any(. == "family-'${output_family}'"))')
echo "${image_family_templates}" | jq -c '.' | while read resource; do
  vm_id=$(echo ${resource} | jq -r '.id | sub("^qemu/"; "")')
  proxmox_node=$(echo ${resource} | jq -r '.node')
  tags=$(echo ${resource} | jq -r '.tags | split(";") | del(.[] | select(. == "latest")) | join(";")')

  # TODO: only show curl output if not http 200
  curl -s https://${PKR_VAR_proxmox_hostname}:8006/api2/json/nodes/${proxmox_node}/qemu/${vm_id}/config -H "Authorization: PVEAPIToken=${PKR_VAR_proxmox_username}=${PKR_VAR_proxmox_token}" -H 'Content-Type: application/json' -X PUT -d '{"node": "'${proxmox_node}'", "vmid": '${vm_id}', "tags": "'${tags}'"}'
done
echo ""

# Name the new image and tag it with metadata
echo "Tagging and naming newest built image"
new_vm_id=$(jq -r '.builds[0].artifact_id' ${image_path}/packer-manifest.json)
resource=$(echo ${raw_resources} | jq '.data[] | select(.id == "qemu/'${new_vm_id}'")')

if [[ -z "$resource" ]]; then
  echo "Could not find newly built VM image"
  exit 1
fi

proxmox_node=$(echo ${resource} | jq -r '.node')
tags=$(echo ${resource} | jq -r '.tags | split(";") + ["image", "family-'${output_family}'", "latest", "build-date-'${build_timestamp//:/-}'"] | del(.[] | select(. == "packer")) | join(";")')

# TODO: only show curl output if not http 200
curl -s https://${PKR_VAR_proxmox_hostname}:8006/api2/json/nodes/${proxmox_node}/qemu/${new_vm_id}/config -H "Authorization: PVEAPIToken=${PKR_VAR_proxmox_username}=${PKR_VAR_proxmox_token}" -H 'Content-Type: application/json' -X PUT -d '{"node": "'${proxmox_node}'", "vmid": '${new_vm_id}', "tags": "'${tags}';latest", "name": "'${output_family}'-'${build_unix}'"}'
echo ""

# Cleanup old previously built images, we only want to keep 5 including the one we just built
image_family_templates_with_unix_build=$(echo ${image_family_templates} | jq '.unix = (.name | capture(".*-(?<unix>[0-9]+$)") | .unix | tonumber)')
image_family_templates_to_clean=$(echo ${image_family_templates_with_unix_build} | jq -s '. | sort_by(.unix) | reverse | if length > 4 then .[4:] else empty end')
echo "${image_family_templates_to_clean}" | jq -c '.[]' | while read resource; do
  vm_name=$(echo ${resource} | jq -r '.name')
  vm_id=$(echo ${resource} | jq -r '.id | sub("^qemu/"; "")')
  proxmox_node=$(echo ${resource} | jq -r '.node')
  echo "Cleaning Old Image ${vm_name} - ${vm_id}"
  # TODO: only show curl output if not http 200
  curl -s https://${PKR_VAR_proxmox_hostname}:8006/api2/json/nodes/${proxmox_node}/qemu/${vm_id} -H "Authorization: PVEAPIToken=${PKR_VAR_proxmox_username}=${PKR_VAR_proxmox_token}" -H 'Content-Type: application/json' -X DELETE
done
