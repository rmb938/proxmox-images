# {{ ansible_managed }}

services {
  name = "prometheus-haproxy-garage"
  id   = "prometheus-haproxy-garage"
  port = 8405

  meta {
    prometheus_scrape = "true"
  }
}