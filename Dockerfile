FROM ubuntu:latest
RUN apt-get update && apt-get install -y apache2 docker.io \
  && apt-get clean \
  && mkdir -p /etc/haproxy \
  && mkdir -p /usr/local/src
COPY . /usr/local/src/haproxy-scripts
RUN rsync -avH /usr/local/src/haproxy-scripts/apache2/ /etc/apache2/
RUN cp -f /usr/local/src/haproxy-scripts/ci-haproxy-cfg.txt /etc/haproxy/haproxy.cfg
RUN /usr/local/src/haproxy-scripts/prep-source
RUN /usr/local/src/haproxy-scripts/install-haproxy-service git-haproxy-master
RUN /usr/local/src/haproxy-scripts/fullstack
RUN /usr/local/src/haproxy-scripts/runci
