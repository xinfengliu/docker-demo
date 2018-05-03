openssl x509 -req -days 365 -sha256 -in server.csr -CA dtr.cert.pem -CAkey dtr.key.pem -CAcreateserial -out server-cert.pem -extfile extfile.cnf
