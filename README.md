# proxmox-images

## Setup

Download ubuntu noble and install qemu-guest agent.
Once done reset cloud-init and truncate machine-id to prevent DHCP issues.

TODO: the VM also has to be made then the image imported, should make a script to do this automatically somehow.

TODO: Also also we need a way automatically update this to the latest release. Probably could make terraform on a cronjob or something.

```bash
wget https://mirrors.rit.edu/ubuntu-cloud/cloud-images/noble/current/noble-server-cloudimg-amd64.img
virt-customize -a noble-server-cloudimg-amd64.img --run-command 'apt update -y' --run-command 'apt install qemu-guest-agent -y' --run-command 'apt clean' --run-command 'cloud-init --debug clean --logs --configs all' --run-command 'truncate -s 0 /etc/machine-id' -v
``` 