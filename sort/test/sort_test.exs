defmodule SortTest do
  use ExUnit.Case
  doctest Sort

  test "expect main to be :ok" do
    assert Sort.main() == :ok
  end
end
