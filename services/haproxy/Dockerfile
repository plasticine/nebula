FROM haproxy:1.6.4
MAINTAINER Justin Morris <desk@pixelbloom.com>

RUN apt-get -y update \
  && apt-get install -y curl bash wget unzip inotify-tools \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN wget --no-check-certificate https://releases.hashicorp.com/consul-template/0.14.0/consul-template_0.14.0_linux_amd64.zip \
  && unzip consul-template_0.14.0_linux_amd64.zip \
  && rm consul-template_0.14.0_linux_amd64.zip \
  && chmod +x consul-template \
  && mv consul-template /usr/local/bin/consul-template

# Copy in self signed derp certificate
ADD ssl/certificate.pem /container/haproxy/ssl/certificate.pem

ADD entrypoint.bash /entrypoint.bash
RUN chmod +x /entrypoint.bash
ENTRYPOINT ["/entrypoint.bash"]
