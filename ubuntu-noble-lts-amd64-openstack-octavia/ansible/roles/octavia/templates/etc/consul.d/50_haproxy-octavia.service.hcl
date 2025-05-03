# {{ ansible_managed }}

services {
  name = "prometheus-haproxy-octavia"
  id   = "prometheus-haproxy-octavia"
  port = 8405

  meta {
    prometheus_scrape = "true"
  }
}