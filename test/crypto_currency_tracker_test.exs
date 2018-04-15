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

    IO.inspect(CryptoCurrencyTracker.Api.get_currency_pricing("btc", "2018-03-02","2018-03-02"))
    IO.inspect(CryptoCurrencyTracker.ApiAgent.get("btc"))
  end

end