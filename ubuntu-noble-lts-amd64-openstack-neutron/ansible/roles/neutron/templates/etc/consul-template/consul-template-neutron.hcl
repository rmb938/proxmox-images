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
  source = "/etc/consul-template/templates/neutron/postgres-server-ca.crt.ctmpl"
  destination = "/etc/neutron/postgres-server-ca.crt"
  create_dest_dirs = false
  perms = "0644"
  exec {
    command = "sudo systemctl reload-or-restart neutron-server || true"
  }
}

# Postgres User
template {
  source = "/etc/consul-template/templates/neutron/postgres-user-neutron.ctmpl"
  destination = "/etc/neutron/postgres-user-neutron.rendered"
  create_dest_dirs = false
  perms = "0600"
  exec {
    command = "sudo systemctl reload-or-restart neutron-server || true"
  }
}


# RabbitMQ CA
template {
  source = "/etc/consul-template/templates/neutron/rabbitmq-server-ca.crt.ctmpl"
  destination = "/etc/neutron/rabbitmq-server-ca.crt"
  create_dest_dirs = false
  perms = "0644"
  exec {
    command = "sudo systemctl reload-or-restart neutron-server || true"
  }
}

# RabbitMQ User
template {
  source = "/etc/consul-template/templates/neutron/rabbitmq-user-neutron.ctmpl"
  destination = "/etc/neutron/rabbitmq-user-neutron.rendered"
  create_dest_dirs = false
  perms = "0600"
  exec {
    command = "sudo systemctl reload-or-restart neutron-server || true"
  }
}

# OVN NB OVSDB CA
template {
  source = "/etc/consul-template/templates/neutron/ovn-nb-ovsdb-ca.crt.ctmpl"
  destination = "/etc/neutron/ovn-nb-ovsdb-ca.crt"
  create_dest_dirs = false
  perms = "0644"
  exec {
    command = "sudo systemctl reload-or-restart neutron-server || true"
  }
}

# OVN NB OVSDB User
template {
  source = "/etc/consul-template/templates/neutron/ovn-nb-ovsdb-user-neutron.ctmpl"
  destination = "/etc/neutron/ovn-nb-ovsdb-user-neutron.rendered"
  create_dest_dirs = false
  perms = "0600"
  exec {
    command = "sudo systemctl reload-or-restart neutron-server || true"
  }
}

# OVN NSB OVSDB CA
template {
  source = "/etc/consul-template/templates/neutron/ovn-sb-ovsdb-ca.crt.ctmpl"
  destination = "/etc/neutron/ovn-sb-ovsdb-ca.crt"
  create_dest_dirs = false
  perms = "0644"
  exec {
    command = "sudo systemctl reload-or-restart neutron-server || true"
  }
}

# OVN SB OVSDB User
template {
  source = "/etc/consul-template/templates/neutron/ovn-sb-ovsdb-user-neutron.ctmpl"
  destination = "/etc/neutron/ovn-sb-ovsdb-user-neutron.rendered"
  create_dest_dirs = false
  perms = "0600"
  exec {
    command = "sudo systemctl reload-or-restart neutron-server || true"
  }
}

# Neutron Config
template {
  source = "/etc/consul-template/templates/neutron/neutron.conf.ctmpl"
  destination = "/etc/neutron/neutron.conf"
  create_dest_dirs = false
  perms = "0600"
  exec {
    command = "sudo systemctl reload-or-restart neutron-server || true"
  }
}

# ML2 Config
template {
  source = "/etc/consul-template/templates/neutron/ml2_conf.ini.ctmpl"
  destination = "/etc/neutron/plugins/ml2/ml2_conf.ini"
  create_dest_dirs = false
  perms = "0600"
  exec {
    command = "sudo systemctl reload-or-restart neutron-server || true"
  }
}