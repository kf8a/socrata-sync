defmodule Socrata.Workers.SellableProductYield do
  use Oban.Worker, queue: :scheduled, max_attempts: 1

  @impl true
  def perform(_args) do
    Socrata.SellableProductData.add_sellable_product_data()
  end
end
