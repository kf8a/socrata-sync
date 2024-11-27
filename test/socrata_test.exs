defmodule SocrataTest do
  use ExUnit.Case
  doctest Socrata

  test "greets the world" do
    assert Socrata.hello() == :world
  end
end
