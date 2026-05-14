defmodule Socrata.Workers.StaticGasFluxWorker do
  use Oban.Worker, queue: :default

  def perform(_args) do
    Socrata.StaticGasFluxData.add_static_gas_flux_data()
  end
end
