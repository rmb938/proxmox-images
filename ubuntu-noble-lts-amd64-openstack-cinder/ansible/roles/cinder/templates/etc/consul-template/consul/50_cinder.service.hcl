# {{ ansible_managed }}

template {
  source = "/etc/consul-template/templates/consul/50_cinder.service.hcl.ctmpl"
  destination = "/etc/consul.d/50_cinder.service.hcl"
  create_dest_dirs = false
  perms = "0600"
  exec {
    command = "sudo systemctl reload-or-restart consul || true"
  }
}