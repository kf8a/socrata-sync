defmodule Socrata.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      Socrata.Repo,
      ObanRepo,
      {Oban, Application.fetch_env!(:socrata, Oban)}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Socrata.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
