defmodule ExSentry.Mixfile do
  use Mix.Project

  def project do
    [app: :exsentry,
     version: "0.6.2",
     elixir: "~> 1.1",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     test_coverage: [tool: ExCoveralls],
     preferred_cli_env: [
       "coveralls": :test,
       "coveralls.detail": :test,
       "coveralls.post": :test
     ],
     description: "ExSentry is a client for the Sentry error reporting platform.",
     package: [
       maintainers: ["pete gamache", "Appcues"],
       licenses: ["MIT"],
       links: %{GitHub: "https://github.com/appcues/exsentry"}
     ],
     docs: [main: ExSentry],
     deps: deps]
  end

  # Type "mix help compile.app" for more information
  def application do
    [
      applications: [
        :logger,
        :fuzzyurl,
        :uuid,
        :timex,
        :hackney,
        :poison,
        :plug,
      ],
      mod: {ExSentry, []}]
  end

  defp deps do
    [
      {:fuzzyurl, "~> 0.9.0"},
      {:uuid, "~> 1.1"},
      {:timex, "~> 2.1"},
      {:hackney, "~> 1.4"},
      {:poison, "~> 1.5 or ~> 2.0"},
      {:plug, "~> 1.0"},
      {:ex_spec, github: "appcues/ex_spec", tag: "1.1.0-elixir13", only: :test},
      {:mock, "~> 0.1.1", only: :test},
      {:excoveralls, "~> 0.4.3", only: :test},
      {:earmark, "~> 0.1", only: :dev},
      {:ex_doc, "~> 0.11", only: :dev},
    ]
  end
end
