defmodule Socrata.Data.StaticGasFluxData do
  @derive {Jason.Encoder,
           only: [
             :site_id,
             :ltar_feature_id,
             :exp_unit_id,
             :date_time,
             :total_lid_closure_time,
             :carbon_dioxide_flux,
             :carbon_dioxide_flux_quality,
             :methane_flux,
             :methane_flux_quality,
             :nitrous_oxide_flux,
             :nitrous_oxide_flux_quality,
             :air_temperature,
             :soil_temperature,
             :soil_temperature_depth,
             :soil_moisture_vol_vwc,
             :soil_moisture_depth,
             :measurement_technique,
             :notes
           ]}
  use Ecto.Schema
  @schema_prefix "ltar"
  @primary_key false

  schema "socrata_static_gas_fluxes" do
    field(:site_id, :string)
    field(:ltar_feature_id, :string)
    field(:exp_unit_id, :string)
    field(:date_time, :utc_datetime)
    field(:total_lid_closure_time, :integer)
    field(:carbon_dioxide_flux, :decimal)
    field(:carbon_dioxide_flux_quality, :integer)
    field(:methane_flux, :decimal)
    field(:methane_flux_quality, :integer)
    field(:nitrous_oxide_flux, :decimal)
    field(:nitrous_oxide_flux_quality, :integer)
    field(:air_temperature, :float)
    field(:soil_temperature, :float)
    field(:soil_temperature_depth, :string)
    field(:soil_moisture_vol_vwc, :float)
    field(:soil_moisture_depth, :string)
    field(:measurement_technique, :string)
    field(:notes, :string)
  end
end
