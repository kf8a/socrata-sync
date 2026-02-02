defmodule Socrata.Data.AnppTest do
  use ExUnit.Case, async: true

  alias Socrata.Data.Anpp
  alias Socrata.Data.Sentinel

  describe "replace_nulls_with_sentinel/1" do
    test "replaces nil integer with -9999" do
      anpp = %Anpp{crop_year: nil}
      result = Sentinel.replace_nulls_with_sentinel(anpp)
      assert result.crop_year == -9999
    end

    test "replaces nil decimal with Decimal -9999" do
      anpp = %Anpp{sampling_area: nil}
      result = Sentinel.replace_nulls_with_sentinel(anpp)
      assert Decimal.equal?(result.sampling_area, Decimal.new(-9999))
    end

    test "leaves non-nil numeric values unchanged" do
      anpp = %Anpp{crop_year: 2023, sampling_area: Decimal.new("1.5")}
      result = Sentinel.replace_nulls_with_sentinel(anpp)
      assert result.crop_year == 2023
      assert Decimal.equal?(result.sampling_area, Decimal.new("1.5"))
    end

    test "leaves nil in non-numeric fields unchanged" do
      anpp = %Anpp{site_id: nil, date: nil}
      result = Sentinel.replace_nulls_with_sentinel(anpp)
      assert result.site_id == nil
      assert result.date == nil
    end

    test "returns new struct and does not mutate input" do
      anpp = %Anpp{crop_year: nil}
      result = Sentinel.replace_nulls_with_sentinel(anpp)
      assert result.crop_year == -9999
      assert anpp.crop_year == nil
    end
  end
end
