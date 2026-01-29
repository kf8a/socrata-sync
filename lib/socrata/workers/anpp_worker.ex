defmodule Socrata.Workers.AnppWorker do
  use Oban.Worker, queue: :scheduled, max_attempts: 1

  @impl true
  def perform(_args) do
    Socrata.Anpp.add_anpp_data()
  end
end
