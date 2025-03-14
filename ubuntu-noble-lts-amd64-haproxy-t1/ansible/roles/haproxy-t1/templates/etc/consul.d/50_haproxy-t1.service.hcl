# {{ ansible_managed }}

services {
  name = "haproxy-t1-http"
  id   = "haproxy-t1-http"
  port = 80
}

services {
  name = "haproxy-t1-https"
  id   = "haproxy-t1-https"
  port = 443
}

services {
  name = "prometheus-haproxy-t1"
  id   = "prometheus-haproxy-t1"
  port = 8405

  meta {
    prometheus_scrape = "true"
  }
}