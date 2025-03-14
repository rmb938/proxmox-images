packer {
  required_plugins {
    name = {
      version = "~> 1"
      source  = "github.com/hashicorp/proxmox"
    }
  }
  required_plugins {
    ansible = {
      version = "~> 1"
      source = "github.com/hashicorp/ansible"
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

source "proxmox-clone" "ubuntu-noble-haproxy-t1" {
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

  // Must have at least one tag, otherwise it shows up as `"tags": " "` in the api.
  tags = "packer"

  cloud_init              = true
  cloud_init_storage_pool = "freenas-nfs"

}

build {
  sources = ["source.proxmox-clone.ubuntu-noble-haproxy-t1"]

  // Packer setup
  provisioner "shell" {
    script = "../scripts/provisioner-shell-image-packer.sh"
  }

  provisioner "ansible" {
    playbook_file   = "ansible/site.yaml"
    user            = "ubuntu"
    extra_arguments = [
      "-v",
      "--diff"
    ]

    ansible_env_vars = ["ANSIBLE_FORCE_COLOR=1"]
  }

  // Trivy
  provisioner "shell" {
    script = "../scripts/provisioner-shell-image-trivy.sh"
  }

  // Cleanup
  provisioner "shell" {
    script = "../scripts/provisioner-shell-image-cleanup.sh"
  }

  post-processor "manifest" {}

}
