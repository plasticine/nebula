defmodule ExCoveralls.Mixfile do
  use Mix.Project

  def project do
    [ app: :excoveralls,
      version: "0.5.5",
      elixir: "~> 1.0",
      deps: deps(),
      description: description(),
      package: package(),
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: cli_env_for(:test, [
        "coveralls", "coveralls.detail", "coveralls.html", "coveralls.post",
      ])
    ]
  end

  defp cli_env_for(env, tasks) do
    Enum.reduce(tasks, [], fn(key, acc) -> Keyword.put(acc, :"#{key}", env) end)
  end

  # Configuration for the OTP application
  def application do
    []
  end

  # Returns the list of dependencies in the format:
  # { :foobar, "~> 0.1", git: "https://github.com/elixir-lang/foobar.git" }
  def deps do
    [
      {:mock, "~> 0.1.1", only: :test},
      {:meck, "~> 0.8.4", only: :test},
      {:exjsx, "~> 3.0"},
      {:hackney, ">= 0.12.0"}
    ]
  end

  defp description do
    """
    Coverage report tool for Elixir with coveralls.io integration.
    """
  end

  defp package do
    [ maintainers: ["parroty"],
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/parroty/excoveralls"} ]
  end
end
