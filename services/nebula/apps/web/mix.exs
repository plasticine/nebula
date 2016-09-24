defmodule Nebula.Web.Mixfile do
  use Mix.Project

  def project do
    [
      app: :web,
      version: "1.0.0",
      elixir: "~> 1.3",
      elixirc_paths: elixirc_paths(Mix.env),
      compilers: [:phoenix, :gettext] ++ Mix.compilers,
      build_path: "../../_build",
      config_path: "../../config/config.exs",
      deps_path: "../../deps",
      lockfile: "../../mix.lock",
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: [
        "coveralls": :test,
        "coveralls.detail": :test,
        "coveralls.html": :test,
        "test.prepare": :test
      ],
      build_embedded: Mix.env == :prod,
      start_permanent: Mix.env == :prod,
      aliases: aliases,
      deps: deps
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {Nebula.Web, []},
      applications: [
        :consul,
        :cowboy,
        :exsentry,
        :gettext,
        :gproc,
        :graphql,
        :httpoison,
        :logger,
        :phoenix,
        :phoenix_ecto,
        :phoenix_html,
        :phoenix_pubsub_redis,
        :plug_graphql,
        :postgrex,
        :timex,
        :timex_ecto,
      ]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "web", "test/support"]
  defp elixirc_paths(_),     do: ["lib", "web"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      {:consul, "~> 1.0.0", git: "https://github.com/plasticine/consul-ex.git", ref: "326b689"},
      {:cowboy, "~> 1.0"},
      {:excoveralls, "~> 0.5", only: [:test, :dev]},
      {:exsentry, "~> 0.6.2"},
      {:gettext, "~> 0.9"},
      {:gproc, "~> 0.5.0"},
      {:graphql, "~> 0.3"},
      {:httpoison, "~> 0.9.0"},
      {:httpotion, "~> 3.0.1"},
      {:phoenix, "~> 1.2.1"},
      {:phoenix_ecto, "~> 3.0"},
      {:phoenix_html, "~> 2.4"},
      {:phoenix_live_reload, "~> 1.0", only: :dev},
      {:phoenix_pubsub_redis, "~> 2.1"},
      {:plug_graphql, "~> 0.3"},
      {:poolboy, "~> 1.5.1"},
      {:postgrex, ">= 0.0.0"},
      {:temp, "~> 0.1"},
      {:timex, "~> 3.0", override: true},
      {:timex_ecto, "~> 3.0"},
    ]
  end

  # Aliases are shortcut or tasks specific to the current project.
  # For example, to create, migrate and run the seeds file at once:
  #
  #     $ mix ecto.setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    [
      "ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      "test.prepare": ["ecto.reset", "ecto.setup"],
      "test.coverage": ["coveralls.html"],
   ]
  end
end
