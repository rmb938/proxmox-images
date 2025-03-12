# {{ ansible_managed }}

vault {
  address = "http://127.0.0.1:8100"
  renew_token = false
  retry {
    # Settings to 0 for unlimited retries.
    attempts = 0
  }
}

template {
  source = "/etc/consul-template/templates/consul/connect_ca.crt.ctmpl"
  destination = "/opt/consul/tls/connect_ca.crt"
  create_dest_dirs = false
  perms = "0600"
  exec {
    command = "sudo systemctl reload-or-restart consul || true"
  }
}

template {
  source = "/etc/consul-template/templates/consul/00_consul.hcl.ctmpl"
  destination = "/etc/consul.d/00_consul.hcl"
  create_dest_dirs = false
  perms = "0600"
  exec {
    command = "sudo systemctl reload-or-restart consul || true"
  }
}