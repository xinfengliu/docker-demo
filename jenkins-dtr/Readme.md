### Demonstrate how jenkins pipeline interacts with DTR (Docker Trusted Registry) in the simplest way

#### Steps :
- run `run-jenkins.sh` to run Jenkins as a container on Ubuntu 16.04 server.
- trust DTR on Ubuntu server where Jenkins container runs. 
  ```shell
  curl https:<DTR addr>/ca | tee /usr/local/share/ca-certificates/dtr.crt
  update-ca-certificates
  sudo systemctl restart docker.service
  ```
  
- On DTR web UI, create a user `jenkins`, an organization `org123` and a repository `hello`.
- On Jenkins web UI, `Manage Jenkins` -> `Configure System` -> `Global properties`:
  - create a global environment variable `DTR_REGISTRY` which is IP address of FQDN of DTR
- On Jenkins web UI, `Credentials` -> `System` -> `Global Crendentials`, create following credentials:
  - ID: `jenkins-dtr` , Kind: `username with password` (this is username/password for Jenkins user in DTR)
  - ID: `image-signing-root-pass`, Kind: `Secret text` (this is used for image signing root passphrase)
  - ID: `image-signing-repo-pass`, Kind: `Secret text` (this is used for image signing repository passphrase)
