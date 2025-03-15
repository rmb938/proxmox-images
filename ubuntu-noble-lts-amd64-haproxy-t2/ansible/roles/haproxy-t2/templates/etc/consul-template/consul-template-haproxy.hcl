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
  source = "/etc/consul-template/templates/haproxy/haproxy.cfg.ctmpl"
  destination = "/etc/haproxy/haproxy.cfg"
  create_dest_dirs = false
  perms = "0644"
  exec {
    command = "sudo systemctl reload-or-restart haproxy || true"
  }
}

template {
  source = "/etc/consul-template/templates/haproxy/http-domain2backend-map.txt.ctmpl"
  destination = "/etc/haproxy/http-domain2backend-map.txt"
  create_dest_dirs = false
  perms = "0644"
  exec {
    command = "sudo systemctl reload-or-restart haproxy || true"
  }
}

template {
  source = "/etc/consul-template/templates/haproxy/step-x5c.ctmpl"
  destination = "/etc/haproxy/step-x5c.rendered"
  create_dest_dirs = false
  perms = "0644"
  exec {
    command = "sudo systemctl reload-or-restart haproxy || true"
  }
}