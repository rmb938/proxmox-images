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
  source = "/etc/consul-template/templates/octavia/postgres-server-ca.crt.ctmpl"
  destination = "/etc/octavia/postgres-server-ca.crt"
  create_dest_dirs = false
  perms = "0644"
  exec {
    command = "sudo systemctl reload-or-restart octavia-api octavia-health-manager octavia-housekeeping octavia-worker octavia-driver-agent || true"
  }
}

# Postgres User
template {
  source = "/etc/consul-template/templates/octavia/postgres-user-octavia.ctmpl"
  destination = "/etc/octavia/postgres-user-octavia.rendered"
  create_dest_dirs = false
  perms = "0600"
  exec {
    command = "sudo systemctl reload-or-restart octavia-api octavia-health-manager octavia-housekeeping octavia-worker octavia-driver-agent || true"
  }
}


# RabbitMQ CA
template {
  source = "/etc/consul-template/templates/octavia/rabbitmq-server-ca.crt.ctmpl"
  destination = "/etc/octavia/rabbitmq-server-ca.crt"
  create_dest_dirs = false
  perms = "0644"
  exec {
    command = "sudo systemctl reload-or-restart octavia-api octavia-health-manager octavia-housekeeping octavia-worker octavia-driver-agent || true"
  }
}

# RabbitMQ User
template {
  source = "/etc/consul-template/templates/octavia/rabbitmq-user-octavia.ctmpl"
  destination = "/etc/octavia/rabbitmq-user-octavia.rendered"
  create_dest_dirs = false
  perms = "0600"
  exec {
    command = "sudo systemctl reload-or-restart octavia-api octavia-health-manager octavia-housekeeping octavia-worker octavia-driver-agent || true"
  }
}

# OVN NB OVSDB CA
template {
  source = "/etc/consul-template/templates/octavia/ovn-nb-ovsdb-ca.crt.ctmpl"
  destination = "/etc/octavia/ovn-nb-ovsdb-ca.crt"
  create_dest_dirs = false
  perms = "0644"
  exec {
    command = "sudo systemctl reload-or-restart octavia-api octavia-health-manager octavia-housekeeping octavia-worker octavia-driver-agent || true"
  }
}

# OVN NB OVSDB User
template {
  source = "/etc/consul-template/templates/octavia/ovn-nb-ovsdb-user-octavia.ctmpl"
  destination = "/etc/octavia/ovn-nb-ovsdb-user-octavia.rendered"
  create_dest_dirs = false
  perms = "0600"
  exec {
    command = "sudo systemctl reload-or-restart octavia-api octavia-health-manager octavia-housekeeping octavia-worker octavia-driver-agent || true"
  }
}

# OVN NSB OVSDB CA
template {
  source = "/etc/consul-template/templates/octavia/ovn-sb-ovsdb-ca.crt.ctmpl"
  destination = "/etc/octavia/ovn-sb-ovsdb-ca.crt"
  create_dest_dirs = false
  perms = "0644"
  exec {
    command = "sudo systemctl reload-or-restart octavia-api octavia-health-manager octavia-housekeeping octavia-worker octavia-driver-agent || true"
  }
}

# OVN SB OVSDB User
template {
  source = "/etc/consul-template/templates/octavia/ovn-sb-ovsdb-user-octavia.ctmpl"
  destination = "/etc/octavia/ovn-sb-ovsdb-user-octavia.rendered"
  create_dest_dirs = false
  perms = "0600"
  exec {
    command = "sudo systemctl reload-or-restart octavia-api octavia-health-manager octavia-housekeeping octavia-worker octavia-driver-agent || true"
  }
}

# Octavia Config
template {
  source = "/etc/consul-template/templates/octavia/octavia.conf.ctmpl"
  destination = "/etc/octavia/octavia.conf"
  create_dest_dirs = false
  perms = "0600"
  exec {
    command = "sudo systemctl reload-or-restart octavia-api octavia-health-manager octavia-housekeeping octavia-worker octavia-driver-agent || true"
  }
}
