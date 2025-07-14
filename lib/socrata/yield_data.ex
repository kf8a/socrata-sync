defmodule Socrata.YieldData do
  import Ecto.Query, only: [from: 2]

  @moduledoc """
  Functions to update the yield data in the Socrata dataset
  """

  # https://ars-datahub.data.socrata.com/resource/anb6-ymxg.json

  @doc """
   Add new yield data to the Socrata dataset

   Checks the date of the last data in the Socrata dataset
   Checks if there is more recent data in the local database
   If there is, it adds the new data to the Socrata dataset
   If there is no more recent data, it does nothing
  """
  def add_yield_data() do
    datasets = Application.fetch_env!(:socrata, Datasets)
    url = Socrata.get_url(datasets[:domain], datasets[:yield_dataset_id])
    {:ok, last_sample_date} = Socrata.get_last_sample("date", url)

    from(u in Socrata.Data.CropYield,
      where: u.date > ^last_sample_date,
      order_by: [asc: u.date]
    )
    |> Socrata.Repo.all()
    |> Socrata.send_to_socrata(url)
  end

  @doc """
  Delete all yield data from the Socrata dataset
  """
  def delete_all() do
    datasets = Application.fetch_env!(:socrata, Datasets)
    url = Socrata.get_url(datasets[:domain], datasets[:yield_dataset_id])
    Socrata.delete_all(url)
  end
end
