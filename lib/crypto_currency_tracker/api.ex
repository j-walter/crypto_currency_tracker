defmodule CryptoCurrencyTracker.Api do
  alias CryptoCurrencyTracker.ApiAgent

  def get(name, user_details) do
    ApiAgent.get(name) || nil
  end


end
