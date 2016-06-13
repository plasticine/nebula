FROM alpine:3.4
MAINTAINER Justin Morris <desk@pixelbloom.com>

ENV S6_OVERLAY_VERSION=v1.17.2.0
ENV CONSUL_TEMPLATE_VERSION=0.15.0
ENV HAPROXY_VERSION=1.6.5-r0

RUN \
  apk add --no-cache \
    bash \
    curl \
    haproxy=${HAPROXY_VERSION} \
  && curl -sSL https://github.com/just-containers/s6-overlay/releases/download/${S6_OVERLAY_VERSION}/s6-overlay-amd64.tar.gz | tar xfz - -C / \
  && curl -sSL https://releases.hashicorp.com/consul-template/${CONSUL_TEMPLATE_VERSION}/consul-template_${CONSUL_TEMPLATE_VERSION}_linux_amd64.zip -o /tmp/consul-template.zip \
  && unzip -d /usr/sbin/ /tmp/consul-template.zip \
  && rm /tmp/consul-template.zip \
  && apk del curl

ADD root /

ENTRYPOINT ["/init"]
EXPOSE 80 443 1936
