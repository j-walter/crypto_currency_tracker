defmodule CryptoCurrencyTracker.Api do
  alias CryptoCurrencyTracker.ApiAgent
    alias CryptoCurrencyTracker.TrackerAgent
  alias CryptoCurrencyTracker.Api

  @digital_currencies TrackerAgent.digital_currencies()


  # if currency_id is nil => return all the currency data that the active user is tracking
  # otherwise return the specific data associated with the requested currency id

  # if user details is nil
  def get_currency(currency_id, user_details) do
    if !currency_id do

      []
    else
      []
    end
  end

  def get_currency_pricing(currency_id, start_date, end_date) when currency_id in @digital_currencies do

  end

  def follow_currency(currency_id, user_details) when not is_nil(user_details) and currency_id in @digital_currencies do

  end

  def unfollow_currency(currency_id, user_details) when not is_nil(user_details) and currency_id in @digital_currencies do
    []
  end

  def enable_currency_alerts(currency_id, user_details, threshold, direction) when not is_nil(user_details) and currency_id in @digital_currencies do
    []
  end

  def disable_currency_alerts(currency_id, user_details) when not is_nil(user_details) and currency_id in @digital_currencies do
    []
  end

  def send_currency_alerts do
    nil
  end

end
