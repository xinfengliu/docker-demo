docker run \
  -u root \
  --rm \
  --name jenkins \
  -d \
  -p 8080:8080 \
  -p 50000:50000 \
  -v jenkins-data:/var/jenkins_home \
  -v /var/run/docker.sock:/var/run/docker.sock:ro \
  -v /home/docker/projects:/home \
  --env JAVA_OPTS="-Xmx1g" \
  jenkinsci/blueocean
