defmodule Socrata.Anpp do
  import Ecto.Query, only: [from: 2]

  @moduledoc """
  Functions to update the ANPP data in the Socrata dataset.

  Dataset: https://ars-datahub.data.socrata.com/resource/4p6n-5gyf.json
  """

  @doc """
  Add new ANPP data to the Socrata dataset.

  Checks the date of the last data in the Socrata dataset, then checks if there
  is more recent data in the local database (via the `ltar.socrata_anpp` view).
  If there is, it adds the new data to the Socrata dataset. If there is no more
  recent data, it does nothing.
  """
  def add_anpp_data() do
    datasets = Application.fetch_env!(:socrata, Datasets)
    url = Socrata.get_url(datasets[:domain], datasets[:anpp_dataset_id])
    {:ok, last_sample_date} = Socrata.get_last_sample("date", url)

    # get_anpp_after_date(last_sample_date)
    get_anpp_after_date()
    |> Enum.map(fn record -> Sentinel.replace_nulls_with_sentinel(record) end)
    |> Socrata.send_to_socrata(url)
  end

  @doc """
  Get all ANPP records, ordered by date ascending.
  """
  def get_anpp_after_date() do
    from(u in Socrata.Data.Anpp,
      where: u.date > ^~D[2022-01-01],
      order_by: [asc: u.date])
    |> Socrata.Repo.all()
  end

  @doc """
  Get ANPP records with date after the given date, ordered by date ascending.
  """
  def get_anpp_after_date(last_sample_date) do
    from(u in Socrata.Data.Anpp,
      where: u.date > ^last_sample_date,
      order_by: [asc: u.date]
    )
    |> Socrata.Repo.all()
  end

  @doc """
  Delete all ANPP data from the Socrata dataset.
  """
  def delete_all() do
    datasets = Application.fetch_env!(:socrata, Datasets)
    url = Socrata.get_url(datasets[:domain], datasets[:anpp_dataset_id])
    Socrata.delete_all(url)
  end
end
