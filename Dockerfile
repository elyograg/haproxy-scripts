FROM ubuntu:latest
RUN apt-get update && apt-get install -y apache2 docker.io rsync sudo
RUN apt-get clean 
RUN ls -al /etc/apache2/sites-available
RUN mkdir -p /etc/haproxy 
RUN mkdir -p /etc/ssl/certs/local
RUN mkdir -p /usr/local/src/haproxy-scripts/apache2
COPY apache2/ports.conf /usr/local/src/haproxy-scripts/apache2/
COPY haproxy.cfg /etc/haproxy/
COPY common-functions.sh /usr/local/src/haproxy-scripts/
COPY fullstack /usr/local/src/haproxy-scripts/
COPY install-haproxy-service /usr/local/src/haproxy-scripts/
COPY new-haproxy /usr/local/src/haproxy-scripts/
COPY new-quic /usr/local/src/haproxy-scripts/
COPY prep-source /usr/local/src/haproxy-scripts/
COPY runci /usr/local/src/haproxy-scripts/
COPY selfsigned.pem /etc/ssl/certs/local/
RUN rsync -avH /usr/local/src/haproxy-scripts/apache2/ /etc/apache2/
RUN /usr/local/src/haproxy-scripts/prep-source
RUN /usr/local/src/haproxy-scripts/install-haproxy-service git-haproxy-master
RUN /usr/local/src/haproxy-scripts/fullstack
RUN /usr/local/src/haproxy-scripts/runci
