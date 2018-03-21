### Demonstrate how jenkins pipeline interacts with DTR (Docker Trusted Registry) in the simplest way

#### Steps:
- trust DTR on Jenkins server. For example, on Ubuntu:
  ```shell
  curl https:<DTR addr>/ca | tee /usr/local/share/ca-certificates/dtr.crt
  update-ca-certificates
  sudo systemctl restart docker.service
  ```
- create a user named 'jenkins' on DTR
- create global crendtials in Jenkins

