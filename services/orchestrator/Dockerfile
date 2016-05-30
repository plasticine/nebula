FROM trenpixster/elixir:1.2.4
MAINTAINER Justin Morris <desk@pixelbloom.com>

RUN apt-get -qq update \
  && apt-get install -y \
    postgresql-client \
    bash \
    inotify-tools \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ENV ROOT /container/app
RUN mkdir -p $ROOT

ARG MIX_ENV
ENV MIX_ENV ${MIX_ENV:-prod}
EXPOSE 4000
WORKDIR $ROOT
ADD ./mix.exs ./mix.exs
ADD ./mix.lock ./mix.lock
RUN mix local.hex --force
RUN mix deps.get deps.compile

ADD ./ $ROOT
RUN mix compile

ADD entrypoint.bash /bin/entrypoint.bash
RUN chmod +x /bin/entrypoint.bash
ENTRYPOINT ["/bin/entrypoint.bash"]
CMD ["phoenix.server"]
