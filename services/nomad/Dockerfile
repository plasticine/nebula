FROM ubuntu:16.04
MAINTAINER Justin Morris <desk@pixelbloom.com>

ENV S6_OVERLAY_VERSION v1.17.2.0
ENV NOMAD_VERSION 0.4.0

RUN \
  apt-get update -y \
  && apt-get install -y \
    apt-transport-https \
    ca-certificates \
  && echo "deb https://apt.dockerproject.org/repo ubuntu-xenial main" > /etc/apt/sources.list.d/docker.list \
  && apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D \
  && apt-get update -y \
  && apt-get install -y \
    curl \
    unzip \
    bash \
    docker-engine \
  && curl -sSL https://releases.hashicorp.com/nomad/${NOMAD_VERSION}/nomad_${NOMAD_VERSION}_linux_amd64.zip -o /tmp/nomad.zip \
  && unzip -o /tmp/nomad.zip -d /usr/local/bin \
  && rm /tmp/nomad.zip \
  && chmod +x /usr/local/bin/nomad

RUN mkdir -p /data/nomad

ADD root /
RUN chmod +x /home/entrypoint.bash

ENTRYPOINT ["/home/entrypoint.bash"]
EXPOSE 4646 4647
