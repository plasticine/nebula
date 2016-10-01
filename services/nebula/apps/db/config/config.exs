use Mix.Config

import_config "#{Mix.env}.exs"

config :db, ecto_repos: [Nebula.Repo]
