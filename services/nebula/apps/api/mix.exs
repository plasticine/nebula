defmodule Nebula.Api.Mixfile do
  use Mix.Project

  def project do
    [app: :api,
     version: "0.0.1",
     build_path: "../../_build",
     config_path: "../../config/config.exs",
     deps_path: "../../deps",
     lockfile: "../../mix.lock",
     elixir: "~> 1.2",
     elixirc_paths: elixirc_paths(Mix.env),
     compilers: [:phoenix, :gettext] ++ Mix.compilers,
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps()]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {Nebula.Api, []},
      applications: [
        :phoenix,
        :phoenix_pubsub,
        :plug_graphql,
        :graphql,
        :cowboy,
        :logger,
        :gettext
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
      {:db, in_umbrella: true},
      {:cowboy, "~> 1.0"},
      {:gettext, "~> 0.11"},
      {:graphql, "~> 0.3"},
      {:phoenix, "~> 1.2.1"},
      {:phoenix_pubsub, "~> 1.0"},
      {:plug_graphql, "~> 0.3"},
    ]
  end
end
