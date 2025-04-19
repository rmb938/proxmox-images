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

# OVN config environment
template {
  source = "/etc/consul-template/templates/ovn/ovn.env.ctmpl"
  destination = "/etc/ovn-ovsdb/ovn.env"
  create_dest_dirs = false
  perms = "0644"
  exec {
    command = "sudo systemctl reload-or-restart ovn-central || true"
  }
}

# OVSDB CA
template {
  source = "/etc/consul-template/templates/ovn/ovsdb-ca.crt.ctmpl"
  destination = "/etc/ovn-ovsdb/ovsdb-ca.crt"
  create_dest_dirs = false
  perms = "0644"
  exec {
    command = "sudo systemctl reload-or-restart ovn-central || true"
  }
}

# OVSDB Server
template {
  source = "/etc/consul-template/templates/ovn/ovsdb-server-cert.ctmpl"
  destination = "/etc/ovn-ovsdb/ovsdb-server-cert.ctmpl.rendered"
  create_dest_dirs = false
  perms = "0644"
  exec {
    command = "sudo systemctl reload-or-restart ovn-central || true"
  }
}

# OVSDB User Northd
template {
  source = "/etc/consul-template/templates/ovn/ovsdb-user-northd.ctmpl"
  destination = "/etc/ovn-ovsdb/ovsdb-user-northd.ctmpl.rendered"
  create_dest_dirs = false
  perms = "0644"
  exec {
    command = "sudo systemctl reload-or-restart ovn-central || true"
  }
}