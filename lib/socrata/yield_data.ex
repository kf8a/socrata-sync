defmodule Socrata.YieldData do
  @moduledoc """
  Functions to update the yield data in the Socrata dataset
  """
  # https://ars-datahub.data.socrata.com/resource/anb6-ymxg.json

  @doc """
  Get Socrata credentials from configuration
  """
  def get_credentials do
    creds = Application.fetch_env!(:socrata, Socrata)

    %Socrata.Api.Credentials{
      api_key: creds[:api_key],
      api_secret: creds[:app_token]
    }
  end

  def get_url do
    creds = Application.fetch_env!(:socrata, Dataset)
    "https://" <> creds[:domain] <> "/resource/" <> creds[:yield_dataset_id] <> ".json"
  end

  @doc """
   Add new yield data to the Socrata dataset

   Checks the date of the last data in the Socrata dataset
   Checks if there is more recent data in the local database
   If there is, it adds the new data to the Socrata dataset
   If there is no more recent data, it does nothing
  """
  def add_yield_data(data) do
    data
    |> Jason.encode!()

  end
end
