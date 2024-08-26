defmodule SpiritTest do
  use ExUnit.Case
  doctest Spirit

  test "greets the world" do
    assert Spirit.hello() == :world
  end
end
