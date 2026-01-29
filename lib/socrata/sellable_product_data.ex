defmodule Socrata.SellableProductData do
  import Ecto.Query, only: [from: 2]

  @moduledoc """
  Functions to update the sellable product data in the Socrata dataset
  """

  # https://ars-datahub.data.socrata.com/resource/anb6-ymxg.json

  @doc """
   Add new yield data to the Socrata dataset

   Checks the date of the last data in the Socrata dataset
   Checks if there is more recent data in the local database
   If there is, it adds the new data to the Socrata dataset
   If there is no more recent data, it does nothing
  """
  def add_sellable_product_data() do
    datasets = Application.fetch_env!(:socrata, Datasets)
    url = Socrata.get_url(datasets[:domain], datasets[:sellable_product_dataset_id])
    {:ok, last_sample_date} = Socrata.get_last_sample("date", url)
    |> IO.inspect(label: "last_sample_date")

    get_sellable_products_after_date(last_sample_date)
    |> IO.inspect(label: "sellable_products")
    |> Socrata.send_to_socrata(url)
  end

  @doc """
  Get sellable products after the given date
  """
  def get_sellable_products_after_date() do
    from(u in Socrata.Data.SellableProduct,
      order_by: [asc: u.date]
    )
    |> Socrata.Repo.all()
  end

  def get_sellable_products_after_date(last_sample_date) do
    from(u in Socrata.Data.SellableProduct,
      where: u.date > ^last_sample_date,
      order_by: [asc: u.date]
    )
    |> Socrata.Repo.all()
  end

  @doc """
  Delete all yield data from the Socrata dataset
  """
  def delete_all() do
    datasets = Application.fetch_env!(:socrata, Datasets)
    url = Socrata.get_url(datasets[:domain], datasets[:sellable_product_dataset_id])
    Socrata.delete_all(url)
  end

end
