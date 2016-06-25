FROM alpine:3.4
MAINTAINER Justin Morris <desk@pixelbloom.com>

ENV S6_OVERLAY_VERSION v1.17.2.0
ENV FABIO_VERSION 1.2rc2

RUN \
  apk add --no-cache \
    curl \
    bash \
  && curl -sSL https://github.com/just-containers/s6-overlay/releases/download/${S6_OVERLAY_VERSION}/s6-overlay-amd64.tar.gz | tar xfz - -C / \
  && curl -sSL https://github.com/eBay/fabio/releases/download/v${FABIO_VERSION}/fabio-${FABIO_VERSION}-go1.6.2_linux-amd64 \
  && chown -R nginx:www-data /var/lib/nginx

ADD root /

VOLUME ["/data/git"]
VOLUME ["/etc/git/templates/repo/hooks"]

ENTRYPOINT ["/init"]
EXPOSE 80 443
