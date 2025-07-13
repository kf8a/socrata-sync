defmodule Socrata do
  @moduledoc """
  Sync met data with socrata
  """

  import Ecto.Query

  def get_url() do
    creds = Application.fetch_env!(:socrata, Datasets)
    "https://" <> creds[:domain] <> "/resource/" <> creds[:weather_dataset_id] <> ".json"
  end

  def get_url(domain, dataset_id) do
    "https://" <> domain <> "/resource/" <> dataset_id <> ".json"
  end

  @doc """
  Add new FiveMinuteData records to Socrata
  """
  def add(url \\ get_url()) do
    {:ok, last_sample} = get_last_sample(url)

    twenty_four_hours_ago = DateTime.utc_now() |> DateTime.add(-24, :hour)

    from(u in Socrata.FiveMinuteData,
      where: u.date_time > ^last_sample,
      where: u.date_time < ^twenty_four_hours_ago,
      order_by: [asc: u.date_time]
    )
    |> Socrata.Repo.all(timeout: :infinity)
    |> Enum.map(fn record -> Map.put(record, :date_time, DateTime.to_naive(record.date_time)) end)
    |> send_to_socrata(url)
  end

  @doc """
  Send batches of data to Socrata

  Socrata has a limit of 100,000 records per request.
  This function sends the data in chunks of 100,000 records.
  It returns the number of records sent.

  TODO: Maybe this should be in the api module
  """
  def send_to_socrata(data, url) do
    data
    |> Enum.chunk_every(100_000)
    |> Enum.each(fn chunk -> Socrata.Api.post(chunk, url, get_credentials()) end)
  end

  @doc """
  Get the most recent sample from Socrata
  """
  def get_last_sample(url) do
    case Socrata.Api.get_last_sample(url, get_credentials()) do
      {:ok, nil} -> DateTime.new(~D[2015-01-01], ~T[00:00:00.000], "Etc/UTC")
      {:ok, last_sample} -> {:ok, last_sample}
      {:error, _} -> {:error, nil}
    end
  end

  @doc """
  Delete all FiveMinuteData records from Socrata
  """
  def delete_all(url) do
    credentials = get_credentials()

    Socrata.Api.delete_all(
      url,
      credentials
    )
  end

  def replace() do
  end

  def get_last_record() do
    from(u in Socrata.FiveMinuteData,
      order_by: [desc: u.date_time],
      limit: 1
    )
    |> Socrata.Repo.one()
  end

  defp get_credentials do
    creds = Application.fetch_env!(:socrata, Socrata)

    %Socrata.Api.Credentials{
      api_key: creds[:api_key],
      api_secret: creds[:app_token]
    }
  end
end
