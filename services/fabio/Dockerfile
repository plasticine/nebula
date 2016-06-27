FROM alpine:3.4
MAINTAINER Justin Morris <desk@pixelbloom.com>

ENV S6_OVERLAY_VERSION v1.17.2.0
ENV FABIO_VERSION 1.1.5

RUN \
  apk add --no-cache \
    curl \
    bash \
  && curl -sSL https://github.com/just-containers/s6-overlay/releases/download/${S6_OVERLAY_VERSION}/s6-overlay-amd64.tar.gz | tar xfz - -C / \
  && curl -sSL https://github.com/eBay/fabio/releases/download/v${FABIO_VERSION}/fabio-${FABIO_VERSION}-go1.6.2_linux-amd64 -o /usr/local/bin/fabio \
  && chmod +x /usr/local/bin/fabio
  # && apk del curl

ADD root /

ENTRYPOINT ["/init"]
EXPOSE 9999 9998
