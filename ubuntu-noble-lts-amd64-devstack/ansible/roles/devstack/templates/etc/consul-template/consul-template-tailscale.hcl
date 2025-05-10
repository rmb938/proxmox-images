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

template {
  source = "/etc/consul-template/templates/tailscale/tailscale-up-auth-key.ctmpl"
  destination = "/etc/tailscale/tailscale-auth-key"
  create_dest_dirs = false
  perms = "0600"
}