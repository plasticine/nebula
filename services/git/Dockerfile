FROM nginx:1.10.0
MAINTAINER Justin Morris <desk@pixelbloom.com>

RUN apt-get -y update \
  && apt-get install -y curl bash wget unzip openssl git fcgiwrap jq python \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ADD conf/nginx.conf /etc/nginx/nginx.conf
ADD conf/proxy.conf /etc/nginx/proxy.conf
ADD conf/sites /etc/nginx/sites
ADD conf/htpasswd /etc/nginx/.htpasswd

EXPOSE 6000

ADD entrypoint.bash /bin/entrypoint.bash
RUN chmod +x /bin/entrypoint.bash
ENTRYPOINT ["/bin/entrypoint.bash"]
CMD []
