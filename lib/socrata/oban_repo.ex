defmodule ObanRepo do
  use Ecto.Repo,
    otp_app: :socrata,
    adapter: Ecto.Adapters.SQLite3
end
