packer {
  required_plugins {
    name = {
      version = "~> 1"
      source  = "github.com/hashicorp/proxmox"
    }
  }
}

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

source "proxmox-clone" "ubuntu-noble-hardened" {
  username    = "${var.proxmox_username}"
  token       = "${var.proxmox_token}"
  proxmox_url = "https://${var.proxmox_hostname}:8006/api2/json"
  node        = "freenas-pm"

  clone_vm_id = "${var.clone_vm_id}"

  sockets     = 1
  cores       = 1
  memory      = 2048

  network_adapters {
    bridge = "vmbr0v52"
    model  = "virtio"
  }

  ipconfig {
    ip = "dhcp"
    ip6 = "auto"
  }

  bios    = "ovmf"
  machine = "q35"

  scsi_controller = "virtio-scsi-single"

  os           = "l26"
  ssh_username = "ubuntu"

  // must have at least one tag, otherwise it shows up as "tags": " ", in the api
  tags = "packer"

  cloud_init              = true
  cloud_init_storage_pool = "freenas-nfs"

}

build {
  sources = ["source.proxmox-clone.ubuntu-noble-hardened"]

  provisioner "shell" {
    inline = [
      "sudo apt update -y", 
      "sudo apt upgrade -y",

      # Need to reset cloud-init and machine id things
      # Never forget this on any builds, otherwise DHCP will hand out the same IPs
      "sudo cloud-init --debug clean --logs --configs all",
      "sudo truncate -s 0 /etc/machine-id /var/lib/dbus/machine-id"
    ]
  }

  post-processor "manifest" {}

}
