defmodule Socrata.Data.SentinelTest do
  use ExUnit.Case, async: true

  alias Socrata.Data.Anpp
  alias Socrata.Data.Sentinel

  describe "replace_nulls_with_sentinel/2" do
    test "accepts custom sentinel value" do
      anpp = %Anpp{crop_year: nil, sampling_area: nil}
      result = Sentinel.replace_nulls_with_sentinel(anpp, -1)
      assert result.crop_year == -1
      assert Decimal.equal?(result.sampling_area, Decimal.new(-1))
    end
  end
end
