FROM trenpixster/elixir:1.3.2
MAINTAINER Justin Morris <desk@pixelbloom.com>

ARG MIX_ENV
ARG NOMAD_VERSION

ENV NOMAD_VERSION ${NOMAD_VERSION}
ENV MIX_ENV ${MIX_ENV}

# Install system stuff
RUN apt-get -qq update \
  && apt-get install -y \
    postgresql-client \
    curl \
    unzip \
    git \
    inotify-tools \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Install Nomad
RUN cd /tmp \
  && curl -sSL https://releases.hashicorp.com/nomad/${NOMAD_VERSION}/nomad_${NOMAD_VERSION}_linux_amd64.zip -o nomad.zip \
  && unzip nomad.zip -d /usr/local/bin/ \
  && chmod +x /usr/local/bin/nomad \
  && rm -rf /tmp/nomad.zip

ENV ROOT /container/app
RUN mkdir -p $ROOT

EXPOSE 4000
WORKDIR $ROOT
ADD ./mix.exs ./mix.exs
ADD ./mix.lock ./mix.lock
RUN mix local.rebar --force
RUN mix local.hex --force
RUN mix deps.get deps.compile 1>&1
RUN epmd -daemon

ADD ./ $ROOT

CMD ["iex -S phoenix.server"]
