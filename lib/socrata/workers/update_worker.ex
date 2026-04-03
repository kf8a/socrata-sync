defmodule Socrata.Workers.UpdateWorker do
  @moduledoc false
  use Oban.Worker, queue: :scheduled, max_attempts: 1

  @impl true
  def perform(_args) do
    Socrata.Weather.add()
  end
end
