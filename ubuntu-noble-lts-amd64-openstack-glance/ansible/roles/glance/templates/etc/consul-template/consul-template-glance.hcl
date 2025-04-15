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

# Postgres CA
template {
  source = "/etc/consul-template/templates/glance/postgres-server-ca.crt.ctmpl"
  destination = "/etc/glance/postgres-server-ca.crt"
  create_dest_dirs = false
  perms = "0644"
  exec {
    command = "sudo systemctl reload-or-restart glance-api || true"
  }
}

# Postgres User
template {
  source = "/etc/consul-template/templates/glance/postgres-user-glance.ctmpl"
  destination = "/etc/glance/postgres-user-glance.rendered"
  create_dest_dirs = false
  perms = "0600"
  exec {
    command = "sudo systemctl reload-or-restart glance-api || true"
  }
}

# Glance Config
template {
  source = "/etc/consul-template/templates/glance/glance-api.conf.ctmpl"
  destination = "/etc/glance/glance-api.conf"
  create_dest_dirs = false
  perms = "0600"
  exec {
    command = "sudo systemctl reload-or-restart glance-api || true"
  }
}