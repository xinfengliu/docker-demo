openssl genrsa -aes256 -out ca-key.pem 4096 
openssl req -subj "/C=CN/ST=Shanghai/L=SH/O=Docker-demo/CN=*.example.com" -new -x509 -days 365 -key ca-key.pem -sha256 -out ca.pem
openssl genrsa -out server-key.pem 4096
openssl req -subj "/C=CN/ST=Shanghai/L=SH/O=Docker-demo/CN=*.example.com" -sha256 -new -key server-key.pem -out server.csr 

#SAN
echo subjectAltName = DNS:*.example.com,IP:192.168.105.78,IP:127.0.0.1 > extfile.cnf 
openssl x509 -req -days 365 -sha256 -in server.csr -CA ca.pem -CAkey ca-key.pem -CAcreateserial -out server-cert.pem -extfile extfile.cnf

cp server-cert.pem cache.cert.pem
cp server-key.pem cache.key.pem
