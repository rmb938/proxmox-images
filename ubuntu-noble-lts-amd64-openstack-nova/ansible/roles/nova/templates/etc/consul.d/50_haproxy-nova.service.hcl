# {{ ansible_managed }}

services {
  name = "prometheus-haproxy-nova"
  id   = "prometheus-haproxy-nova"
  port = 8405

  meta {
    prometheus_scrape = "true"
  }
}