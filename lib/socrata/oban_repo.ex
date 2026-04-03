defmodule ObanRepo do
   @moduledoc false
  use Ecto.Repo,
    otp_app: :socrata,
    adapter: Ecto.Adapters.SQLite3
end
