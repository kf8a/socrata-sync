defmodule Socrata do
  @moduledoc """
  Sync met data with socrata
  """

  import Ecto.Query

  @doc """
  Get Socrata credentials from configuration
  """
  def get_credentials do
    creds = Application.fetch_env!(:socrata, Socrata)

    %Socrata.Api.Credentials{
      api_key: creds[:socrata_api_key],
      api_secret: creds[:socrata_app_token]
    }
  end

  def get_url do
    creds = Application.fetch_env!(:socrata, Socrata)
    creds[:socrata_domain] <> "/resource/" <> creds[:socrata_dataset_id] <> ".json"
  end

  @doc """
  Add new FiveMinuteData records to Socrata

  """
  def add() do
    # url = "https://ars-datahub.data.socrata.com/resource/8a69-vy3a.json"
    url = get_url()
    credentials = get_credentials()

    {:ok, last_sample} =
      case Socrata.Api.get_last_sample(url, credentials) do
        {:ok, nil} -> DateTime.new(~D[2015-01-01], ~T[00:00:00.000], "Etc/UTC")
        {:ok, last_sample} -> {:ok, last_sample}
        {:error, _} -> {:ok, nil}
      end

    twenty_four_hours_ago = DateTime.utc_now() |> DateTime.add(-24, :hour)

    from(u in Socrata.FiveMinuteData,
      where: u.date_time > ^last_sample,
      where: u.date_time < ^twenty_four_hours_ago,
      order_by: [asc: u.date_time]
    )
    |> Socrata.Repo.all(timeout: :infinity)
    |> Enum.map(fn record -> Map.put(record, :date_time, DateTime.to_naive(record.date_time)) end)
    |> Enum.chunk_every(100_000)
    |> Enum.each(fn chunk -> Socrata.Api.post(url, chunk, credentials) end)

    :ok
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

  def naive_eastern(%DateTime{} = dt) do
    dt
    |> DateTime.shift_zone!("EST")
    |> DateTime.to_naive()
  end

  def get_last_record() do
    from(u in Socrata.FiveMinuteData,
      order_by: [desc: u.date_time],
      limit: 1
    )
    |> Socrata.Repo.one()
  end
end
