# {{ ansible_managed }}

services {
  name = "prometheus-node-exporter"
  id   = "prometheus-node-exporter"
  port = 9100

  meta {
    prometheus_scrape = "true"
  }

  check {
    id = "prometheus-node-exporter-http"
    http = "http://127.0.0.1:9100"
    interval = "10s"
  }
}