defmodule Socrata.Data.SellableProduct do
  @derive {Jason.Encoder,
           only: [
             :site_id,
             :ltar_feature_id,
             :exp_unit_id,
             :crop_year,
             :date,
             :plant,
             :plant_population,
             :exported_product_yield,
             :product_moisture,
             :product_test_weight,
             :notes
           ]}
  use Ecto.Schema
  @schema_prefix "ltar"
  @primary_key false

  schema "socrata_sellable_product" do
    field(:site_id, :string)
    field(:ltar_feature_id, :string)
    field(:exp_unit_id, :string)
    field(:crop_year, :integer)
    field(:date, :date)
    # This is the crop in our parlance
    field(:plant, :string)
    field(:plant_population, :decimal)
    field(:exported_product_yield, :decimal)
    field(:product_moisture, :decimal)
    field(:product_test_weight, :float)
    field(:notes, :string)
  end
end
