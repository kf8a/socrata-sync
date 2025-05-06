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

  We need to do this recursively because the Socrata API only
  allows us to delete 50,000 records at a time. And we need to sleep,
  since the API will return before the data is actually deleted.
  """
  def delete_all() do
    api_key = get_auth_info()

    query("$select": ":id", "$limit": 50_000)
    |> delete_all(api_key)
  end

  def delete_all(%Req.Response{status: 200, body: []}, _api_key) do
    IO.puts("done")
  end

  def delete_all(%Req.Response{status: 200, body: body}, api_key) do
    delete(body, api_key)

    :timer.sleep(10_000)

    query("$select": ":id", "$limit": 50_000)
    |> delete_all(api_key)
  end

  def delete_all(%Req.Response{status: 404}, _api_key) do
    IO.puts("No data found")
  end

  def delete_all(other) do
    raise "Unknown response #{inspect(other)}"
  end

  defp delete(body, api_key) do
    data =
      body
      |> Enum.map(fn x -> Map.put(x, ":deleted", true) end)
      |> Jason.encode!()

    Req.post(
      "https://ars-datahub.data.socrata.com/resource/8a69-vy3a.json",
      auth: {:basic, "#{api_key[:key]}:#{api_key[:secret]}"},
      body: data
    )
    |> IO.inspect()
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
  add multiple records to the dataset
  """
  def post(data) do
    api_key = get_auth_info()

    data =
      data
      |> Jason.encode!()

    Req.post(
      "https://ars-datahub.data.socrata.com/resource/8a69-vy3a.json",
      auth: {:basic, "#{api_key[:key]}:#{api_key[:secret]}"},
      body: data
    )
  end

  @doc """
  update or add one record to the Socrata dataset
  """
  def put(data) do
    api_key = get_auth_info()

    data =
      data
      |> Jason.encode!()

    Req.put(
      "https://ars-datahub.data.socrata.com/resource/8a69-vy3a.json",
      auth: {:basic, "#{api_key[:key]}:#{api_key[:secret]}"},
      body: data
    )
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
