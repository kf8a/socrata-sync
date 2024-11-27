defmodule Socrata.Api do
  @moduledoc """
  Provide a simple interface to the Socrata API
  """

  @doc """
  return all of the records in the Socrata dataset
  """
  def read do
    query([])
  end

  @doc """
  Return the date_time of the most recent record in the Socrata dataset
  """
  def get_last_sample() do
    case query("$select": "max(date_time)") do
      %Req.Response{status: 200, body: body} ->
        {:ok, hd(body)["max_date_time"]}

      %Req.Response{status: 404} ->
        {:error, "No data found"}

      other ->
        {:error, "Unknown response: #{inspect(other)}"}
    end
  end

  @doc """
  delete all records in the Socrata dataset
  """
  def delete_all() do
    case query("$select": ":id") do
      %Req.Response{status: 200, body: body} ->
        Enum.map(body, fn %{":id" => id} -> delete(id) end)
        |> IO.inspect()

      %Req.Response{status: 404} ->
        IO.puts("No data found")

      other ->
        IO.puts("Unknown response: #{inspect(other)}")
    end
  end

  @doc """
  delete the record with the provided row_id from the Socrata dataset
  """
  def delete(id) do
    api_key = get_auth_info()

    Req.delete!(
      "https://ars-datahub.data.socrata.com/resource/8a69-vy3a/#{id}.json",
      auth: {:basic, "#{api_key[:key]}:#{api_key[:secret]}"}
    )
  end

  @doc """
  write new data to the Socrata dataset
  """
  def post(data) do
    api_key = get_auth_info()

    data =
      data
      |> Jason.encode!()

    Req.put(
      "https://ars-datahub.data.socrata.com/resource/8a69-vy3a.json",
      auth: {:basic, "#{api_key[:key]}:#{api_key[:secret]}"},
      body: data
    )
    |> IO.inspect()
  end

  defp get_auth_info() do
    {:ok, api_key} = System.fetch_env("SOCRATA_API_KEY")
    {:ok, api_secret} = System.fetch_env("SOCRATA_APP_TOKEN")
    %{key: api_key, secret: api_secret}
  end

  defp query(query) do
    api_key = get_auth_info()

    Req.get!(
      "https://ars-datahub.data.socrata.com/resource/8a69-vy3a.json",
      params: query,
      auth: {:basic, "#{api_key[:key]}:#{api_key[:secret]}"}
    )
  end
end
