defmodule Socrata do
  @moduledoc """
  Sync met data with socrata
  """

  import Ecto.Query

  def add() do
    {:ok, last_sample} =
      case Socrata.Api.get_last_sample() do
        {:ok, nil} -> DateTime.new(~D[2015-01-01], ~T[00:00:00.000], "Etc/UTC")
        {:ok, last_sample} -> {:ok, last_sample}
        {:error, _} -> {:ok, nil}
      end

    from(u in Socrata.FiveMinuteData,
      where: u.date_time > ^last_sample,
      order_by: [asc: u.date_time],
      limit: 2
    )
    |> Socrata.Repo.all()
    |> Enum.map(fn record -> Map.put(record, :date_time, DateTime.to_naive(record.date_time)) end)
    |> Socrata.Api.post()
  end

  def replace() do
  end
end
