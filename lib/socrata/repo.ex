defmodule Socrata.Repo do
  use Ecto.Repo,
    otp_app: :socrata,
    adapter: Ecto.Adapters.Postgres
end
