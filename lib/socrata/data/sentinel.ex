defmodule Socrata.Data.Sentinel do
  @moduledoc """
  Replaces null values in Ecto structs with a numeric sentinel (-9999).

  Used when exporting data to systems (e.g. Socrata) that represent missing
  numeric values with a sentinel rather than null.
  """

  @default_sentinel -9999

  @doc """
  Replaces null values in numeric fields with -9999 (sentinel for missing data).

  Only applies to integer, decimal, and float fields; string, date, and boolean
  fields are unchanged. Works with any Ecto struct.
  Returns a new struct.
  """
  def replace_nulls_with_sentinel(struct, sentinel \\ @default_sentinel) do
    module = struct.__struct__
    fields = module.__schema__(:fields)

    struct
    |> Map.from_struct()
    |> Enum.map(fn {key, value} ->
      type = if key in fields, do: module.__schema__(:type, key), else: nil
      new_value = sentinel_for(type, value, sentinel)
      {key, new_value}
    end)
    |> Map.new()
    |> then(&struct!(module, &1))
  end

  defp sentinel_for(:integer, nil, sentinel), do: sentinel
  defp sentinel_for(:decimal, nil, sentinel), do: Decimal.new(sentinel)
  defp sentinel_for(:float, nil, sentinel), do: sentinel * 1.0
  defp sentinel_for(_, value, _), do: value
end
