defmodule Socrata.StaticGasFluxData do
  @moduledoc """
  Functions to update the gas chamber data in the Socrata dataset
  """

  import Ecto.Query, only: [from: 2]

  def add_static_gas_flux_data() do
    datasets = Application.fetch_env!(:socrata, Datasets)
    url = Socrata.get_url(datasets[:domain], datasets[:gas_data_id])
    {:ok, last_sample_date} = Socrata.get_last_sample("date_time", url)

    get_static_gas_flux_data_after_date(last_sample_date)
    |> Socrata.send_to_socrata(url)
  end

  def get_static_gas_flux_data_after_date() do
    from(u in Socrata.Data.StaticGasFluxData,
      order_by: [asc: u.date_time]
    )
    |> Socrata.Repo.all()
  end

  def get_static_gas_flux_data_after_date(last_sample_date) do
    from(u in Socrata.Data.StaticGasFluxData,
      where: u.date_time > ^last_sample_date,
      order_by: [asc: u.date_time]
    )
    |> Socrata.Repo.all()
  end

  def delete_all() do
    datasets = Application.fetch_env!(:socrata, Datasets)
    url = Socrata.get_url(datasets[:domain], datasets[:gas_data_id])
    Socrata.delete_all(url)
  end
end
