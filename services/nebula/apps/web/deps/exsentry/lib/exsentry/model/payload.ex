defmodule ExSentry.Model.Payload do
  @moduledoc false

  # ExSentry.Model.Payload represents the entire request body of an
  # HTTP POST request to Sentry.

  @derive [Poison.Encoder]

  defstruct platform: "other",
            release: nil,
            modules: nil,
            event_id: nil,
            message: nil,
            timestamp: nil,
            level: nil,
            logger: nil,
            platform: nil,

            culprit: nil,
            server_name: nil,
            release: nil,
            tags: nil,
            modules: nil,
            extra: nil,
            fingerprint: nil,

            stacktrace: nil,
            request: nil,
            user: nil,
            exception: nil, # TODO model
            template: nil,  # TODO model
            logentry: nil,  # TODO model
            query: nil      # TODO model


  @doc ~S"""
  Returns a JSON-compatible body for Sentry HTTP requests.
  """
  @spec from_opts([atom: any]) :: map
  def from_opts(opts \\ []) do
    versions = ExSentry.Utils.versions
    now = Timex.DateTime.now |> Timex.format!("{YYYY}-{0M}-{0D}T{0h24}:{0m}:{0s}")

    ## attributes
    event_id = opts[:event_id] || UUID.uuid4() |> String.replace("-", "")
    timestamp = opts[:timestamp] || now
    message = opts[:message] && String.slice(to_string(opts[:message]), 0..999)
    level = opts[:level] || :error
    logger = opts[:logger] || "ExSentry #{versions[:exsentry]}"
    server_name = opts[:server_name] || :inet.gethostname |> elem(1) |> to_string
    culprit = opts[:culprit]
    tags = opts[:tags]
    extra = opts[:extra]
    fingerprint = opts[:fingerprint]

    ## interfaces -- if provided, inputs must be in proper format,
    ## preferably ExSentry.Model.* structs
    stacktrace = opts[:stacktrace]
    request = opts[:request]
    user = opts[:user]
    exception = opts[:exception]
    template = opts[:template]
    logentry = opts[:logentry]
    query = opts[:query]

    %ExSentry.Model.Payload{
      platform: "other", ## no official love for Elixir yet
      release: versions[:exsentry],
      modules: versions,

      event_id: event_id,
      timestamp: timestamp,
      message: message |> String.slice(0..999),
      level: level,
      logger: logger,
      server_name: server_name,
      culprit: culprit,
      tags: tags,
      extra: extra,
      fingerprint: fingerprint,

      stacktrace: stacktrace,
      request: request,
      user: user,
      exception: exception,
      template: template,
      logentry: logentry,
      query: query
    }
  end


  @doc ~S"""
  Returns an X-Sentry-Auth header value based on the given ExSentry
  `version`, `key`, and `secret` (required) and unix `timestamp`
  (optional, defaults to now).
  """
  @spec get_auth_header_value(map) :: String.t
  def get_auth_header_value(%{version: version, key: key, secret: secret}=args) do
    ts = Map.get(args, :timestamp) || ExSentry.Utils.unixtime
    "Sentry sentry_version=7, " <>
    "sentry_client=\"ExSentry/#{version}\", " <>
    "sentry_timestamp=#{ts}, " <>
    "sentry_key=#{key}, " <>
    "sentry_secret=#{secret}"
  end

end
