FROM ubuntu:16.04
MAINTAINER Justin Morris <desk@pixelbloom.com>

ENV S6_OVERLAY_VERSION v1.17.2.0
ENV NOMAD_VERSION 0.4.0-rc2

RUN \
  apt-get update -y \
  && apt-get install -y \
    curl \
    unzip \
    bash \
  && curl -sSL https://releases.hashicorp.com/nomad/${NOMAD_VERSION}/nomad_${NOMAD_VERSION}_linux_amd64.zip -o /tmp/nomad.zip \
  && unzip -o /tmp/nomad.zip -d /usr/local/bin \
  && rm /tmp/nomad.zip \
  && chmod +x /usr/local/bin/nomad

ADD root /

ENTRYPOINT ["/usr/local/bin/nomad"]
CMD ["agent", "-dev", "-bind=0.0.0.0", "-log-level=INFO", "-config=/etc/nomad/nomad.json"]
EXPOSE 4646 4647
