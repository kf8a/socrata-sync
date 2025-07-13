defmodule Socrata.Workers.UpdateYieldWorker do
  use Oban.Worker, queue: :scheduled, max_attempts: 1

  @impl true
  def perform(_args) do
    Socrata.YieldData.add_yield_data()
  end
end
