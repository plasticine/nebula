FROM alpine:3.4
MAINTAINER Justin Morris <desk@pixelbloom.com>

ENV S6_OVERLAY_VERSION v1.17.2.0
ENV NGINX_VERSION 1.6.5
ENV GIT_PROJECT_ROOT /data/git

RUN \
  apk add --no-cache \
    curl \
    bash \
    python \
    jq \
    nginx \
    git \
    spawn-fcgi \
    fcgiwrap \
  && curl -sSL https://github.com/just-containers/s6-overlay/releases/download/${S6_OVERLAY_VERSION}/s6-overlay-amd64.tar.gz | tar xfz - -C / \
  && chown -R nginx:www-data /var/lib/nginx \
  && ln -sf /dev/stdout /var/log/nginx/access.log \
  && ln -sf /dev/stderr /var/log/nginx/error.log \
  && mkdir -p ${GIT_PROJECT_ROOT}

ADD root /

VOLUME ["/data/git"]
VOLUME ["/etc/git/templates/repo/hooks"]

ENTRYPOINT ["/init"]
EXPOSE 80 443
