FROM nginx:1.10.0
MAINTAINER Justin Morris <desk@pixelbloom.com>

RUN apt-get -y update \
  && apt-get install -y curl bash wget unzip openssl git fcgiwrap \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN wget --no-check-certificate https://releases.hashicorp.com/consul-template/0.14.0/consul-template_0.14.0_linux_amd64.zip \
  && unzip consul-template_0.14.0_linux_amd64.zip \
  && rm consul-template_0.14.0_linux_amd64.zip \
  && chmod +x consul-template \
  && mv consul-template /usr/local/bin/consul-template

ADD conf/nginx.conf /etc/nginx/nginx.conf
ADD conf/proxy.conf /etc/nginx/proxy.conf
ADD conf/sites /etc/nginx/sites

ADD entrypoint.bash /bin/entrypoint.bash
RUN chmod +x /bin/entrypoint.bash
ENTRYPOINT ["/bin/entrypoint.bash"]
CMD []
