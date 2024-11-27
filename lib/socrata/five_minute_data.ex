defmodule Socrata.FiveMinuteData do
  @derive {Jason.Encoder,
           only: [
             :site_id,
             :ltar_feature_id,
             :station_id,
             :calendar_year,
             :date_time,
             :record_type,
             :air_temperature,
             :wind_speed,
             :wind_direction,
             :relative_humidity,
             :precipitation,
             :air_pressure,
             :par,
             :short_wave_in,
             :long_wave_in
           ]}

  use Ecto.Schema

  @schema_prefix "weather"
  schema "ltar_met_data" do
    field(:site_id, :string)
    field(:ltar_feature_id, :string)
    field(:station_id, :string)
    field(:calendar_year, :integer)
    field(:date_time, :utc_datetime)
    field(:record_type, :string)
    field(:air_temperature, :float)
    field(:wind_speed, :float)
    field(:wind_direction, :float)
    field(:relative_humidity, :float)
    field(:precipitation, :float)
    field(:air_pressure, :float)
    field(:par, :float)
    field(:short_wave_in, :float)
    field(:long_wave_in, :float)
  end
end
