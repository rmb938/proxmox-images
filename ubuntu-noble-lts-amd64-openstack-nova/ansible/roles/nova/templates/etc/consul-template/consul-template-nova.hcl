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
  source = "/etc/consul-template/templates/nova/postgres-server-ca.crt.ctmpl"
  destination = "/etc/nova/postgres-server-ca.crt"
  create_dest_dirs = false
  perms = "0644"
  exec {
    command = "sudo systemctl reload-or-restart nova-api nova-scheduler nova-conductor nova-novncproxy || true"
  }
}

# Postgres User - nova-api
template {
  source = "/etc/consul-template/templates/nova/postgres-user-nova-api.ctmpl"
  destination = "/etc/nova/postgres-user-nova-api.rendered"
  create_dest_dirs = false
  perms = "0600"
  exec {
    command = "sudo systemctl reload-or-restart nova-api nova-scheduler nova-conductor nova-novncproxy || true"
  }
}

# Postgres User - nova
template {
  source = "/etc/consul-template/templates/nova/postgres-user-nova.ctmpl"
  destination = "/etc/nova/postgres-user-nova.rendered"
  create_dest_dirs = false
  perms = "0600"
  exec {
    command = "sudo systemctl reload-or-restart nova-api nova-scheduler nova-conductor nova-novncproxy || true"
  }
}

# Postgres User - nova-cell0
template {
  source = "/etc/consul-template/templates/nova/postgres-user-nova-cell0.ctmpl"
  destination = "/etc/nova/postgres-user-nova-cell0.rendered"
  create_dest_dirs = false
  perms = "0600"
  exec {
    command = "sudo systemctl reload-or-restart nova-api nova-scheduler nova-conductor nova-novncproxy || true"
  }
}

# Postgres User - nova-cell1
template {
  source = "/etc/consul-template/templates/nova/postgres-user-nova-cell1.ctmpl"
  destination = "/etc/nova/postgres-user-nova-cell1.rendered"
  create_dest_dirs = false
  perms = "0600"
  exec {
    command = "sudo systemctl reload-or-restart nova-api nova-scheduler nova-conductor nova-novncproxy || true"
  }
}

# RabbitMQ CA
template {
  source = "/etc/consul-template/templates/nova/rabbitmq-server-ca.crt.ctmpl"
  destination = "/etc/nova/rabbitmq-server-ca.crt"
  create_dest_dirs = false
  perms = "0644"
  exec {
    command = "sudo systemctl reload-or-restart nova-api nova-scheduler nova-conductor nova-novncproxy || true"
  }
}

# RabbitMQ User
template {
  source = "/etc/consul-template/templates/nova/rabbitmq-user-nova-controller.ctmpl"
  destination = "/etc/nova/rabbitmq-user-nova-controller.rendered"
  create_dest_dirs = false
  perms = "0600"
  exec {
    command = "sudo systemctl reload-or-restart nova-api nova-scheduler nova-conductor nova-novncproxy  || true"
  }
}

# Nova Config
template {
  source = "/etc/consul-template/templates/nova/nova.conf.ctmpl"
  destination = "/etc/nova/nova.conf"
  create_dest_dirs = false
  perms = "0600"
  exec {
    command = "sudo systemctl reload-or-restart nova-api nova-scheduler nova-conductor nova-novncproxy || true"
  }
}