use Mix.Config

# For development, we disable any cache and enable
# debugging and code reloading.
#
# The watchers configuration can be used to run external
# watchers to your application. For example, we use it
# with brunch.io to recompile .js and .css sources.
config :orchestrator, Orchestrator.Endpoint,
  http: [port: 4000],
  debug_errors: true,
  code_reloader: true,
  reloadable_paths: ["web", "lib"],
  check_origin: false,
  watchers: []

# Watch static and templates for browser reloading.
config :orchestrator, Orchestrator.Endpoint,
  live_reload: [
    patterns: [
      ~r{priv/static/.*(js|css|png|jpeg|jpg|gif|svg)$},
      ~r{priv/gettext/.*(po)$},
      ~r{web/views/.*(ex)$},
      ~r{web/templates/.*(eex)$}
    ]
  ]

# Do not include metadata nor timestamps in development logs
config :logger, :console, format: "[$level] $message\n"

# Set a higher stacktrace during development.
# Do not configure such in production as keeping
# and calculating stacktraces is usually expensive.
config :phoenix, :stacktrace_depth, 20

# Configure your database
config :orchestrator, Orchestrator.Repo,
  adapter: Ecto.Adapters.Postgres,
  hostname: "postgres",
  username: "postgres",
  port: 5432,
  database: "orchestrator_dev",
  pool_size: 10 # The amount of database connections in the pool
