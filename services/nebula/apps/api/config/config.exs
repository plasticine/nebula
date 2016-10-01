# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :api,
  namespace: Nebula.Api,
  ecto_repos: []

config :phoenix,
  serve_endpoints: true

# Configures the endpoint
config :api, Nebula.Api.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "htx3VzscYh+ytLPCUFJXViJZttHNjuTgIXJxKPDSIxoGBFfdaBrqcpYIZ3j0QG8f",
  render_errors: [view: Nebula.Api.ErrorView, accepts: ~w(json)],
  pubsub: [name: Nebula.Api.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
