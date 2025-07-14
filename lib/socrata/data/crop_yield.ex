defmodule Socrata.Data.CropYield do
  @derive {Jason.Encoder,
           only: [
             :site_id,
             :ltar_feature_id,
             :crop_year,
             :date,
             :plant,
             :plant_population,
             :exported_product_yield,
             :product_moisture,
             :notes
           ]}
  use Ecto.Schema
  @schema_prefix "ltar"
  @primary_key false

  schema "socrata_crop_yield" do
    field(:site_id, :string)
    field(:ltar_feature_id, :string)
    # field(:experimental_unit_id, :integer)
    field(:crop_year, :integer)
    field(:date, :date)
    # This is the crop in our parlance
    field(:plant, :string)
    field(:plant_population, :decimal)
    field(:exported_product_yield, :float)
    # Socrata uses text
    field(:product_moisture, :float)
    # Socrata uses text
    # field(:product_test_weight, :float)
    field(:notes, :string)
  end
end
