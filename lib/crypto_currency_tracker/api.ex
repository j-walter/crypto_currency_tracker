defmodule CryptoCurrencyTracker.Api do
  alias CryptoCurrencyTracker.ApiAgent

  # if currency_id is nil => return all the currency data that the active user is tracking
  # otherwise return the specific data associated with the requested currency id
  def get_currency(currency_id, user_details) do
    if !currency_id do
      # return model
      []
    else
      []
    end
  end

  def get_currency_pricing(currency_id, start_date, end_date) do
    [3.23, 4.34, 33.4]
  end

  def follow_currency(currency_id, user_details) do
    []
  end

  def unfollow_currency(currency_id, user_details) do
    []
  end

  def enable_currency_alerts(currency_id, user_details, threshold, direction) do
    []
  end

  def disable_currency_alerts(currency_id, user_details) do
    []
  end

  def send_currency_alerts do
    nil
  end

end
