defmodule Socrata.Data.CropYield do
  use Ecto.Schema
  @schema_prefix "ltar"

  schema "socrata_crop_yield" do
    field(:site_id, :string)
    field(:ltar_feature_id, :string)
    field(:experimental_unit_id, :integer)
    field(:crop_year, :integer)
    field(:harvest_date, :date)
    field(:crop, :string) # plant in socrata parlance
    field(:plant_population, :float) #
    field(:dry_crop_yield, :float) # Socrata uses exported_product_yield as text
    field(:product_moisture, :float) # Socrata uses text
    field(:product_test_weight, :float) # Socrata uses text
    field(:notes, :string)
  end
end
