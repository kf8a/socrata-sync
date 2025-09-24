defmodule Socrata.MixProject do
  use Mix.Project

  def project do
    [
      app: :socrata,
      version: "0.1.0",
      elixir: "~> 1.17",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {Socrata.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:ecto_sql, "~> 3.12"},
      {:ecto_sqlite3, "~> 0.17"},
      {:req, "~> 0.5.7"},
      {:postgrex, "~> 0.21.0"},
      {:oban, "~> 2.17"},
      {:igniter, "~> 0.5"},
      # {:oban_web, "~> 2.11"},
      {:tz, "~> 0.28"},
      {:telemetry_metrics_prometheus, "~> 1.1"},
      {:ex_doc, "~> 0.34", only: :dev, runtime: false},
      {:dialyxir, "~> 1.4", only: [:dev, :test], runtime: false},
      {:credo, "~> 1.7", only: [:dev, :test], runtime: false}
    ]
  end
end
