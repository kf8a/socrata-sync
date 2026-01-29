defmodule Socrata do
  @moduledoc """
  Sync met data with socrata
  """

  def get_url(domain, dataset_id) do
    "https://" <> domain <> "/resource/" <> dataset_id <> ".json"
  end

  @doc """
  Send batches of data to Socrata

  Socrata has a limit of 100,000 records per request.
  This function sends the data in chunks of 100,000 records.
  It returns the number of records sent.

  TODO: Maybe this should be in the api module
  """
  def send_to_socrata(data, url) do
    credentials = get_credentials()

    data
    |> Enum.chunk_every(100_000)
    |> Enum.map(fn chunk -> Socrata.Api.post(chunk, url, credentials) end)
  end

  @doc """
  Get the most recent sample from Socrata
  """
  def get_last_sample(time_field, url) do
    case Socrata.Api.get_last_sample(time_field, url, get_credentials()) do
      {:ok, nil} -> DateTime.new(~D[2015-01-01], ~T[00:00:00.000], "Etc/UTC")
      {:ok, last_sample} -> {:ok, last_sample}
      {:error, msg} -> {:error, msg}
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

  defp get_credentials do
    creds = Application.fetch_env!(:socrata, Socrata)

    %Socrata.Api.Credentials{
      api_key: creds[:api_key],
      api_secret: creds[:app_token]
    }
  end
end
