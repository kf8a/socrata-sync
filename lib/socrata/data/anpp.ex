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
    field(:location_id, :integer)
    field(:experiment_unit_id, :string)
    field(:crop_year, :integer)
    field(:calendar_year, :integer)
    field(:date, :date)
    field(:plant, :string)
    field(:area_m2, :integer)
    field(:plant_population, :string)
    field(:is_this_biomass_leaving_or_staying_in_the_field, :string)
    field(:what_portion_of_the_plant_is_this, :string)
    field(:above_ground_biomass, :decimal)
    field(:aboveground_biomass_c_conc, :string)
    field(:aboveground_biomass_n_conc, :string)
    field(:aboveground_biomass_p_conc, :string)
    field(:aboveground_biomass_k_conc, :string)
    field(:aboveground_biomass_s_conc, :string)
    field(:aboveground_biomass_adf_conc, :string)
    field(:aboveground_biomass_ash_conc, :string)
    field(:aboveground_biomass_crude_protein_conc, :string)
    field(:aboveground_biomass_ligin_conc, :string)
    field(:aboveground_biomass_ndf_conc, :string)
    field(:notes, :string)
  end
end
