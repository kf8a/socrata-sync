defmodule Socrata.MixProject do
  use Mix.Project

  def project do
    [
      app: :socrata,
      version: "0.1.0",
      elixir: "~> 1.17",
      usage_rules: usage_rules(),
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
      {:usage_rules, "~> 1.0", only: [:dev]},
      {:ecto_sql, "~> 3.12"},
      {:ecto_sqlite3, "~> 0.17"},
      {:req, "~> 0.5"},
      {:postgrex, "~> 0.22.0"},
      {:oban, "~> 2.17"},
      {:igniter, "~> 0.5"},
      # {:oban_web, "~> 2.11"},
      {:tz, "~> 0.28"},
      {:telemetry_metrics_prometheus, "~> 1.1"},
      {:ex_doc, "~> 0.34", only: :dev, runtime: false},
      {:credence, "~> 0.7", only: [:dev, :test], runtime: false},
      {:dialyxir, "~> 1.4", only: [:dev, :test], runtime: false},
      {:credo, "~> 1.7", only: [:dev, :test], runtime: false}
    ]
  end

  defp usage_rules do
    # Example for those using claude.
    [
      file: "AGENTS.md",
      # rules to include directly in CLAUDE.md
      usage_rules: ["usage_rules:all"],
      skills: [
        location: ".agents/skills",
        # build skills that combine multiple usage rules
        build: []
      ]
    ]
  end
end
