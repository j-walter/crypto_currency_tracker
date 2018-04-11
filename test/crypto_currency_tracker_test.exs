defmodule CryptoCurrencyTrackerTest do
  use ExUnit.Case
  doctest CryptoCurrencyTracker

  test "Basic tests" do
    IO.inspect(Jason.decode(CryptoCurrencyTracker.Api.get_currency_pricing("BTC", nil, nil).body))
  end

end