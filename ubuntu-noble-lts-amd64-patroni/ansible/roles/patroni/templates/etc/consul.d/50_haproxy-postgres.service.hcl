# {{ ansible_managed }}

services {
  name = "prometheus-haproxy-postgres"
  id   = "prometheus-haproxy-postgres"
  port = 8405

  meta {
    prometheus_scrape = "true"
  }
}