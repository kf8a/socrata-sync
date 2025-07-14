defmodule Socrata.Api do
  @moduledoc """
  Provide a simple interface to the Socrata API
  """

  @doc """
  return all of the records in the Socrata dataset
  """
  def read(url, credentials) do
    query([], url, credentials)
  end

  @doc """
  Return the date_time of the most recent record in the Socrata dataset
  """
  def get_last_sample(time_field, url, credentials) do
    case query(["$select": "max(#{time_field})"], url, credentials) do
      %Req.Response{status: 200, body: body} ->
        {:ok, hd(body)["max_date_time"]}

      %Req.Response{status: 404} ->
        {:error, "No data found you might not have the right permissions"}

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
  def delete_all(url, credentials) do
    query(["$select": ":id", "$limit": 50_000], url, credentials)
    |> IO.inspect()
    |> delete_all(url, credentials)
  end

  def delete_all(%Req.Response{status: 200, body: []}, _url, _credentials) do
    {:ok, :done}
  end

  def delete_all(%Req.Response{status: 200, body: body}, url, credentials) do
    IO.inspect(body, label: "body")

    delete(body, url, credentials)
    |> IO.inspect(label: "delete")

    :timer.sleep(10_000)

    query(["$select": ":id", "$limit": 50_000], url, credentials)
    |> IO.inspect()
    |> delete_all(url, credentials)
    |> IO.inspect(label: "delete_all")
  end

  def delete_all(%Req.Response{status: 404}, _url, _credentials) do
    :ok
  end

  def delete_all(other, _url, _credentials) do
    raise "Unknown response #{inspect(other)}"
  end

  @doc """
  delete the record with the provided row_id from the Socrata dataset
  """
  def delete(id, url, credentials) when is_integer(id) do
    Req.delete!(
      "#{url}/#{id}.json",
      auth: {:basic, "#{credentials.api_key}:#{credentials.api_secret}"}
    )
  end

  def delete(body, url, credentials) when is_list(body) do
    data =
      body
      |> Enum.map(fn x -> Map.put(x, ":deleted", true) end)
      |> Jason.encode!()

    Req.post(
      url,
      auth: {:basic, "#{credentials.api_key}:#{credentials.api_secret}"},
      body: data
    )
  end

  @doc """
  add multiple records to the dataset
  """
  def post(data, url, credentials) do
    data =
      data
      |> Jason.encode!()

    Req.post(
      url,
      auth: {:basic, "#{credentials.api_key}:#{credentials.api_secret}"},
      body: data
    )
  end

  @doc """
  update or add one record to the Socrata dataset
  """
  def put(data, url, credentials) do
    data =
      data
      |> Jason.encode!()

    Req.put(
      url,
      auth: {:basic, "#{credentials.api_key}:#{credentials.api_secret}"},
      body: data
    )
  end

  defp query(query, url, credentials) do
    Req.get!(
      url,
      params: query,
      auth: {:basic, "#{credentials.api_key}:#{credentials.api_secret}"}
    )
  end
end
