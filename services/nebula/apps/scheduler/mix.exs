defmodule Nebula.Scheduler.Mixfile do
  use Mix.Project

  def project do
    [app: :scheduler,
     version: "0.1.0",
     build_path: "../../_build",
     config_path: "../../config/config.exs",
     deps_path: "../../deps",
     lockfile: "../../mix.lock",
     elixir: "~> 1.3",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    [
      mod: {Nebula.Scheduler.Supervisor, []},
      applications: [
        :logger,
        :gproc,
      ]
    ]
  end

  defp deps do
    [
      {:db, in_umbrella: true},
      {:gproc, "~> 0.5.0"},
    ]
  end
end
