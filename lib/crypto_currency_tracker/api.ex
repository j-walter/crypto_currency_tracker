defmodule CryptoCurrencyTracker.Api do
  alias CryptoCurrencyTracker.ApiAgent

  defp cb_headers() do
    ["CB-VERSION": "2015-04-08", "Accept": "Application/json; Charset=utf-8"]
  end

  defp cb_digital_currencies() do
    ["BTC", "LTC", "ETH"]
  end

  defp cb_options() do
    [ssl: [{:versions, [:'tlsv1.2']}], recv_timeout: 500]
  end

  # if currency_id is nil => return all the currency data that the active user is tracking
  # otherwise return the specific data associated with the requested currency id

  # if user details is nil
  def get_currency(currency_id, user_details) do
    if !currency_id do
      # return model
      []
    else
      []
    end
  end

  def get_currency_pricing(currency_id, start_date, end_date) do
    if currency_id in cb_digital_currencies() do
      HTTPoison.start
      response = HTTPoison.get!("https://api.coinbase.com/v2/prices/" <> currency_id <> "-USD/buy", cb_headers(), cb_options())

    else
      {}
    end
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
