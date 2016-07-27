FROM trenpixster/elixir:1.2.5
MAINTAINER Justin Morris <desk@pixelbloom.com>

RUN apt-get -qq update \
  && apt-get install -y \
    postgresql-client \
    curl \
    unzip \
    git \
    inotify-tools \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN cd /tmp \
  && curl -sSL https://releases.hashicorp.com/nomad/0.3.2/nomad_0.3.2_linux_amd64.zip -o nomad.zip \
  && unzip nomad.zip -d /usr/local/bin/ \
  && chmod +x /usr/local/bin/nomad \
  && rm -rf /tmp/nomad.zip

ENV ROOT /container/app
RUN mkdir -p $ROOT

ARG MIX_ENV
ENV TERM xterm
ENV MIX_ENV ${MIX_ENV:-prod}
EXPOSE 4000
WORKDIR $ROOT
ADD ./mix.exs ./mix.exs
ADD ./mix.lock ./mix.lock
RUN mix local.rebar --force
RUN mix local.hex --force
RUN mix deps.get deps.compile
RUN epmd -daemon

ADD ./ $ROOT
RUN mix compile

CMD ["iex -S phoenix.server"]
