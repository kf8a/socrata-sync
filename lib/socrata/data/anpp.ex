defmodule Socrata.Data.Anpp do
  @moduledoc """
  Ecto schema for the `ltar.socrata_anpp` view.

  The view aggregates ANPP (above-ground net primary production) data from
  `ltar.ltar_anpp` with location and plant code lookups.
  """
  use Ecto.Schema
  @schema_prefix "ltar"
  @primary_key false

  schema "socrata_anpp" do
    field(:site_id, :string)
    field(:ltar_feature_id, :string)
    field(:exp_unit_id, :string)
    field(:crop_year, :integer)
    field(:date, :date)
    field(:plant, :string)
    field(:sampling_area, :decimal)
    field(:plants_in_sampling_area, :decimal)
    field(:is_this_biomass_leaving_or, :boolean)
    field(:what_portion_of_the_plant, :string)
    field(:aboveground_biomass, :decimal)
    field(:aboveground_biomass_c_conc, :decimal)
    field(:aboveground_biomass_n_conc, :decimal)
    field(:aboveground_biomass_p_conc, :decimal)
    field(:aboveground_biomass_k_conc, :decimal)
    field(:aboveground_biomass_s_conc, :decimal)
    field(:aboveground_biomass_adf_conc, :decimal)
    field(:aboveground_biomass_ash_conc, :decimal)
    field(:aboveground_biomass_crude, :decimal)
    field(:aboveground_biomass_lignin, :decimal)
    field(:aboveground_biomass_ndf_conc, :decimal)
    field(:notes, :string)
  end
end

defimpl Jason.Encoder, for: Socrata.Data.Anpp do
  @encode_only [
    :site_id,
    :ltar_feature_id,
    :exp_unit_id,
    :crop_year,
    :date,
    :plant,
    :sampling_area,
    :plants_in_sampling_area,
    :is_this_biomass_leaving_or,
    :what_portion_of_the_plant,
    :aboveground_biomass,
    :aboveground_biomass_c_conc,
    :aboveground_biomass_n_conc,
    :aboveground_biomass_p_conc,
    :aboveground_biomass_k_conc,
    :aboveground_biomass_s_conc,
    :aboveground_biomass_adf_conc,
    :aboveground_biomass_ash_conc,
    :aboveground_biomass_crude,
    :aboveground_biomass_lignin,
    :aboveground_biomass_ndf_conc,
    :notes
  ]

  @string_fields [:is_this_biomass_leaving_or]

  def encode(struct, opts) do
    map =
      struct
      |> Map.from_struct()
      |> Map.take(@encode_only)
      |> coerce_string_fields()

    Jason.Encode.map(map, opts)
  end

  defp coerce_string_fields(map) do
    Enum.reduce(@string_fields, map, fn key, acc ->
      Map.update(acc, key, nil, &to_string_if_present/1)
    end)
  end

  defp to_string_if_present(nil), do: nil
  defp to_string_if_present(value), do: to_string(value)
end
