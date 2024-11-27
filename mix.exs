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
      {:ecto_sqlite3, "~> 0.17.5"},
      {:req, "~> 0.5.7"},
      {:postgrex, "~> 0.19.3"},
      {:oban, "~> 2.17"}
    ]
  end
end
