# {{ ansible_managed }}

vault {
  address = "http://127.0.0.1:8100"
  renew_token = false
  retry {
    # Settings to 0 for unlimited retries.
    attempts = 0
  }
}

consul {
  address = "127.0.0.1:8500"
  retry {
    # Settings to 0 for unlimited retries.
    attempts = 0
  }
}

wait {
  min = "15s"
  max = "30s"
}

# Garage Config
template {
  source = "/etc/consul-template/templates/garage/garage.toml.ctmpl"
  destination = "/etc/garage/garage.toml"
  create_dest_dirs = false
  perms = "0600"
  exec {
    command = "sudo systemctl reload-or-restart garage || true"
  }
}

# RPC Secret File
template {
  source = "/etc/consul-template/templates/garage/rpc_secret.ctmpl"
  destination = "/etc/garage/rpc_secret"
  create_dest_dirs = false
  perms = "0600"
  exec {
    command = "sudo systemctl reload-or-restart garage || true"
  }
}