# {{ ansible_managed }}

vault {
  # This is set via /etc/vault.d/vault.env so it can be overwritten
  retry {
    # Setting to a large number, vault agent doesn't have unlimited retries.
    num_retries = 2147483647
  }
}

auto_auth {
  method "cert" {
    mount_path = "auth/step-cert"
    config {
      client_cert = "/opt/vault/tls/vault.crt"
      client_key = "/opt/vault/tls/vault.key"
      reload = true
    }
  }
}

api_proxy {
  use_auto_auth_token = "force"
}

listener "tcp" {
  // TODO: see if we can switch this to /run/vault/vault.sock
  address = "127.0.0.1:8100"
  tls_disable = true # no tls locally, probably not great but no easy way around it
}