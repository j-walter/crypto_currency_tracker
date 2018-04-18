defmodule CryptoCurrencyTrackerTest do
  use ExUnit.Case
  alias CryptoCurrencyTracker.Repo
  alias CryptoCurrencyTracker.User
  alias CryptoCurrencyTracker.Alert
  alias CryptoCurrencyTracker.Mailer
  alias CryptoCurrencyTracker.Api
  alias CryptoCurrencyTracker.Email
  doctest CryptoCurrencyTracker

  test "Basic tests" do
    case Repo.insert(%User{email: "test@test.com", id: "123"}) do
      {:ok, user} ->
        IO.inspect(Alert.insert_or_update("btc", user, [45.4]))
        IO.inspect(Alert.delete("btc", user))
        IO.inspect(Api.get_currency(nil, user))
      _ ->
        nil
    end

    #IO.inspect(CryptoCurrencyTracker.Api.get_currency_pricing("btc", "2018-03-02","2018-03-03"))
    #IO.inspect(CryptoCurrencyTracker.ApiAgent.get("btc"))
    #IO.inspect(Email.passed_digital_currency_threshold("btc", ["test@test.com"], 45.6, 45.4, 45.8)
    #|> Mailer.deliver_later())
  end

end