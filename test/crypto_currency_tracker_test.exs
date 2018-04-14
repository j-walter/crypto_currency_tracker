defmodule CryptoCurrencyTrackerTest do
  use ExUnit.Case
  alias CryptoCurrencyTracker.Repo
  alias CryptoCurrencyTracker.User
  alias CryptoCurrencyTracker.Alert
  doctest CryptoCurrencyTracker

  test "Basic tests" do
    case Repo.insert(%User{email: "test@test.com", id: "123"}) do
      {:ok, user} ->
        IO.inspect(Alert.insert_or_update("btc", user, [45.4]))
        IO.inspect(Alert.delete("btc", user))
      _ ->
        nil
    end

    #IO.inspect(CryptoCurrencyTracker.Api.get_currency_pricing("BTC", nil, nil))
  end

end