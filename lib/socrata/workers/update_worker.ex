defmodule Socrata.Workers.UpdateWorker do
  use Oban.Worker, queue: :scheduled, max_attempts: 1

  @impl true
  def perform(_args) do
    IO.puts("Updating data")
    Socrata.add()
  end
end
