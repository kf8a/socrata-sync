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
      |> IO.inspect()

    twenty_four_hours_ago = DateTime.utc_now() |> DateTime.add(-24, :hour)

    from(u in Socrata.FiveMinuteData,
      where: u.date_time > ^last_sample,
      where: u.date_time < ^twenty_four_hours_ago,
      order_by: [asc: u.date_time]
    )
    |> Socrata.Repo.all(timeout: :infinity)
    |> Enum.map(fn record -> Map.put(record, :date_time, DateTime.to_naive(record.date_time)) end)
    |> Enum.chunk_every(100_000)
    |> Enum.each(fn chunk -> Socrata.Api.post(chunk) end)
  end

  def deleta_all() do
    Socrata.Api.delete_all()
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
