function client_cert(txn, t)
  local der = txn.f:ssl_c_der()
  local chain_der = txn.f:ssl_c_chain_der()

  if type(der) == 'nil' then
    return
  end

  local pem_w_chain = "-----BEGIN CERTIFICATE-----"
  pem_w_chain = pem_w_chain .. "\n"
  pem_w_chain = pem_w_chain .. txn.c:base64(der)
  pem_w_chain = pem_w_chain .. "\n"
  pem_w_chain = pem_w_chain .. "-----END CERTIFICATE-----"

  pem_w_chain = txn.c:url_enc(pem_w_chain, "query")

  if t == "req" then
    txn.http:req_add_header("X-SSL-Client-Cert", pem_w_chain)
  end
  if t == "res" then
    txn.http:res_add_header("X-SSL-Client-Cert", pem_w_chain)
  end

  if type(chain_der) ~= 'nil' then
    local pem_w_chain = "-----BEGIN CERTIFICATE-----"
    pem_w_chain = pem_w_chain .. "\n"
    pem_w_chain = pem_w_chain .. txn.c:base64(chain_der)
    pem_w_chain = pem_w_chain .. "\n"
    pem_w_chain = pem_w_chain .. "-----END CERTIFICATE-----"

    pem_w_chain = txn.c:url_enc(pem_w_chain, "query")

    if t == "req" then
      txn.http:req_add_header("X-SSL-Client-Cert", pem_w_chain)
    end
    if t == "res" then
      txn.http:res_add_header("X-SSL-Client-Cert", pem_w_chain)
    end
  end

end

core.register_action("clientcert", { "http-req", "http-res" }, client_cert, 1)