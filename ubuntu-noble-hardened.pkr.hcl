packer {
  required_plugins {
    name = {
      version = "~> 1"
      source  = "github.com/hashicorp/proxmox"
    }
  }
}

variable "proxmox_username" {
  type = string
  default = "root@pam!packer"
}

variable "proxmox_token" {
  type    = string
  default = "e960bb5a-56f5-48d2-a2d2-bbc9fa520b9c"
}

source "proxmox-clone" "ubuntu-noble-hardened" {
  username    = "${var.proxmox_username}"
  token       = "${var.proxmox_token}"
  proxmox_url = "https://freenas-pm.rmb938.me:8006/api2/json"

  clone_vm_id = 108

  sockets     = 1
  cores       = 1
  memory      = 2048

  node = "freenas-pm"

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

  cloud_init              = true
  cloud_init_storage_pool = "local-zfs"

  tags = "image;family-ubuntu-2404-lts-amd64"

  template_name = "ubuntu-noble-${formatdate("YYYYMMDD-hhmmss", timestamp())}"
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
}
