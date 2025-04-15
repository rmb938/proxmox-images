# {{ ansible_managed }}

services {
  name = "prometheus-haproxy-glance-api"
  id   = "prometheus-haproxy-glance-api"
  port = 8405

  meta {
    prometheus_scrape = "true"
  }
}