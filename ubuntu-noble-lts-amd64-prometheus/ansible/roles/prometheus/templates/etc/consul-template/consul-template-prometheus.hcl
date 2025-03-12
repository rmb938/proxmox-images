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

template {
  source = "/etc/consul-template/templates/prometheus/consul_servers.yml.ctmpl"
  destination = "/etc/prometheus/scrape_configs/consul_servers.yml"
  create_dest_dirs = false
  perms = "0600"
  exec {
    command = "sudo systemctl reload-or-restart prometheus || true"
  }
}