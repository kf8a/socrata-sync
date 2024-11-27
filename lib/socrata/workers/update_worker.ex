defmodule Socrata.Workers.UpdateWorker do
  use Oban.Worker, queue: :scheduled, max_attempts: 10

  @one_hour 3600_000

  @impl true
  def perform(_args) do
    %{}
    |> new(schedule_in: @one_hour)
    |> Oban.insert!()
  end
end
