FROM haproxy:1.6.4
MAINTAINER Justin Morris <desk@pixelbloom.com>

ENV CONSUL_TEMPLATE_VERSION=0.15.0

RUN apt-get -qq update \
  && apt-get install -y \
    curl \
    bash \
    unzip \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN cd /tmp \
  && curl -sSL https://releases.hashicorp.com/consul-template/${CONSUL_TEMPLATE_VERSION}/consul-template_${CONSUL_TEMPLATE_VERSION}_linux_amd64.zip -o consul-template.zip
  && unzip consul-template.zip \
  && rm consul-template.zip \
  && chmod +x consul-template \
  && mv consul-template /usr/local/bin/consul-template

# Copy in self signed derp certificate
ADD ssl/certificate.pem /container/haproxy/ssl/certificate.pem

ADD haproxy.cfg /container/haproxy/conf/haproxy.cfg

ADD entrypoint.bash /entrypoint.bash
RUN chmod +x /entrypoint.bash
ENTRYPOINT ["/entrypoint.bash"]
