defmodule Nebula.Mixfile do
  use Mix.Project

  def project do
    [
      app: :nebula,
      version: "0.0.1",
      elixir: "~> 1.0",
      elixirc_paths: elixirc_paths(Mix.env),
      compilers: [:phoenix, :gettext] ++ Mix.compilers,
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
      mod: {Nebula, []},
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
      {:consul, "~> 1.0.0", git: "https://github.com/plasticine/consul-ex.git", branch: "upgrade-deps"},
      {:cowboy, "~> 1.0"},
      {:excoveralls, "~> 0.5", only: [:test, :dev]},
      {:exsentry, "~> 0.3.0"},
      {:gettext, "~> 0.9"},
      {:gproc, "~> 0.5.0"},
      {:graphql, "~> 0.3"},
      {:httpoison, "~> 0.8.3"},
      {:phoenix, "~> 1.1.4"},
      {:phoenix_ecto, "~> 2.0"},
      {:phoenix_html, "~> 2.4"},
      {:phoenix_live_reload, "~> 1.0", only: :dev},
      {:phoenix_pubsub_redis, "~> 2.0.0"},
      {:plug_graphql, "~> 0.3"},
      {:poolboy, "~> 1.5.1"},
      {:postgrex, ">= 0.0.0"},
      {:temp, "~> 0.4"},
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
