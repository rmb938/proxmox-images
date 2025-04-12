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
  source = "/etc/consul-template/templates/cinder/postgres-server-ca.crt.ctmpl"
  destination = "/etc/cinder/postgres-server-ca.crt"
  create_dest_dirs = false
  perms = "0644"
  exec {
    command = "sudo systemctl reload-or-restart cinder-scheduler apache2 || true"
  }
}

# Postgres User
template {
  source = "/etc/consul-template/templates/cinder/postgres-user-cinder.ctmpl"
  destination = "/etc/cinder/postgres-user-cinder.rendered"
  create_dest_dirs = false
  perms = "0600"
  exec {
    command = "sudo systemctl reload-or-restart cinder-scheduler apache2 || true"
  }
}

# RabbitMQ CA
template {
  source = "/etc/consul-template/templates/cinder/rabbitmq-server-ca.crt.ctmpl"
  destination = "/etc/cinder/rabbitmq-server-ca.crt"
  create_dest_dirs = false
  perms = "0644"
  exec {
    command = "sudo systemctl reload-or-restart cinder-scheduler || true"
  }
}

# RabbitMQ User
template {
  source = "/etc/consul-template/templates/cinder/rabbitmq-user-cinder.ctmpl"
  destination = "/etc/cinder/rabbitmq-user-cinder.rendered"
  create_dest_dirs = false
  perms = "0600"
  exec {
    command = "sudo systemctl reload-or-restart cinder-scheduler || true"
  }
}

# Cinder Config
template {
  source = "/etc/consul-template/templates/cinder/cinder.conf.ctmpl"
  destination = "/etc/cinder/cinder.conf"
  create_dest_dirs = false
  perms = "0600"
  exec {
    command = "sudo systemctl reload-or-restart cinder-scheduler apache2 || true"
  }
}