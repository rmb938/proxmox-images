# {{ ansible_managed }}

services {
  name = "prometheus-haproxy-neutron"
  id   = "prometheus-haproxy-neutron"
  port = 8405

  meta {
    prometheus_scrape = "true"
  }
}