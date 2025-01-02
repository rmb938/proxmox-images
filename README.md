# proxmox-images

Packer automation to build VM Templates for Proxmox.

All image assume you start with a Ubuntu based system with cloud-init installed.

## Setup

Download a Ubuntu cloud image and install qemu-guest agent.
Once done reset cloud-init and truncate machine-id to prevent DHCP issues.

TODO: the VM also has to be made then the image imported, should make a script to do this automatically somehow.

TODO: Also we need a way automatically update this to the latest release. Probably could make terraform on a cronjob or something.

```bash
wget https://mirrors.rit.edu/ubuntu-cloud/cloud-images/noble/current/noble-server-cloudimg-amd64.img
virt-customize -a noble-server-cloudimg-amd64.img --run-command 'apt update -y' --run-command 'apt install qemu-guest-agent -y' --run-command 'apt clean' --run-command 'cloud-init --debug clean --logs --configs all' --run-command 'truncate -s 0 /etc/machine-id' -v
```

Then import it to the VM

```bash
qm importdisk 101 noble-server-cloudimg-amd64.img freenas-nfs --format qcow2
```

## Image Families

This system uses a concept called Image Families. It allows building multiple images
within the same family. See [GCP Image Families](https://cloud.google.com/compute/docs/images/image-management-best-practices#image_families) for details.

Anything deployed or downstream images can automatically use and find the latest 
image in the family.

Once a image is built it will get the `latest` label.

Up to 5 images total will be kept in the image family for easy rollback.

## Labels and Naming

VM Tempaltes will be named `${family}-${unix_timestamp}`. Do not change the name
or remove labels as it will cause the automation to get confused.

VM Templates will have the following tags

`build-date-${date}` - This label automatically gets added to all images built
`family-${family}` - Contains the name of the image family
`image` - Label stating that this Template is an image
`latest` - Dictates that this is the latest image

## Folder Structure and Configuration

All images should follow this structure

```
.
└── image_name/
    ├── base-image-family
    └── main.pkr.hcl
```

`image_name` - Is the name of the image family for this new image.

`base-image-family` - contains the name of the image family this image should build off of.

`main.pkr.hcl` - your packer configuration, must be named this.

### Packer Configuration

Your packer configuration should contain the following variables

```hcl
variable "proxmox_hostname" {
  type = string
}

variable "proxmox_username" {
  type = string
}

variable "proxmox_token" {
  type = string
}

variable "clone_vm_id" {
  type = number
}
```

And in your source

```hcl
source "proxmox-clone" "image_name" {
  username    = "${var.proxmox_username}"
  token       = "${var.proxmox_token}"
  proxmox_url = "https://${var.proxmox_hostname}:8006/api2/json"
  node        = "freenas-pm"

  clone_vm_id = "${var.clone_vm_id}"
}
```

#### Scripts

The first provsioner for your build should be the following to things know they are
in a packer build. See script for details

```hcl
provisioner "shell" {
  script = "../scripts/provisioner-shell-image-packer.sh"
}
```

The last provisioner for your build should be the following to make sure all images
are in a clean state after building. See script for details

```hcl
provisioner "shell" {
  script = "../scripts/provisioner-shell-image-cleanup.sh"
}
```

## Run

Export the following environment variables

```bash
export PKR_VAR_proxmox_hostname=""
export PKR_VAR_proxmox_username=""
export PKR_VAR_proxmox_token=""
```

TODO: add env about not saving image if in a pr

Run the following replacing `${path_to_image}` with the folder your `main.pkr.hcl` is in.

```bash
./build-image.sh ${path_to_image}
```

Once your image is built you will see something similar to this in the Proxmox UI

