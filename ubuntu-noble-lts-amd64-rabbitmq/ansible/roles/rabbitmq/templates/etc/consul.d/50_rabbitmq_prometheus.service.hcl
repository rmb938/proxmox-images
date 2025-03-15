# {{ ansible_managed }}

services {
  name = "prometheus-rabbitmq"
  id   = "prometheus-rabbitmq"
  port = 15692

  meta {
    prometheus_scrape = "true"
  }
}