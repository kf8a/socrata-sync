defmodule Socrata.Weather do
  @moduledoc """
  Functions to update the weather data in the Socrata dataset
  """

  import Ecto.Query, only: [from: 2]

  def add() do
    url = get_url()
    {:ok, last_sample} = Socrata.get_last_sample(get_url())

    twenty_four_hours_ago = DateTime.utc_now() |> DateTime.add(-24, :hour)

    from(u in Socrata.Data.FiveMinuteData,
      where: u.date_time > ^last_sample,
      where: u.date_time < ^twenty_four_hours_ago,
      order_by: [asc: u.date_time]
    )
    |> Socrata.Repo.all(timeout: :infinity)
    |> Enum.map(fn record -> Map.put(record, :date_time, DateTime.to_naive(record.date_time)) end)
    |> Socrata.send_to_socrata(url)
  end

  @doc """
  Delete all weather data from the Socrata dataset
  """
  def delete_all() do
    url = get_url()
    Socrata.delete_all(url)
  end

  defp get_url() do
    creds = Application.fetch_env!(:socrata, Datasets)
    "https://" <> creds[:domain] <> "/resource/" <> creds[:weather_dataset_id] <> ".json"
  end
end
