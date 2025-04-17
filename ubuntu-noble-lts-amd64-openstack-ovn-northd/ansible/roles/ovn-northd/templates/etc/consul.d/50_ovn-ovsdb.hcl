# {{ ansible_managed }}

services {
  name = "openstack-ovn-nb-ovsdb"
  id   = "openstack-ovn-nb-ovsdb"
  port = 6641

  check = {
    id = "openstack-ovn-nb-ovsdb"
    name = "OVN NB OVSDB on port 6641"
    tcp = "localhost:6641"
    interval = "30s"
    timeout = "5s"
  }
}

services {
  name = "openstack-ovn-sb-ovsdb"
  id   = "openstack-ovn-sb-ovsdb"
  port = 6642

  check = {
    id = "openstack-ovn-sb-ovsdb"
    name = "OVN SB OVSDB on port 6642"
    tcp = "localhost:6642"
    interval = "30s"
    timeout = "5s"
  }
}