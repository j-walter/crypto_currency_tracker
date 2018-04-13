defmodule CryptoCurrencyTracker.Api do
  alias CryptoCurrencyTracker.ApiAgent

  @cb_headers ["CB-VERSION": "2016-02-18"]

  @cb_digital_currencies ["BTC", "LTC", "ETH"]

  @cb_options [ssl: [{:versions, [:'tlsv1.2']}], recv_timeout: 500]

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

  def get_currency_pricing(currency_id, start_date, end_date) when currency_id in @cb_digital_currencies do
    case HTTPoison.get("https://api.coinbase.com/v2/prices/" <> currency_id <> "-USD/buy", @cb_headers, @cb_options) do
      {:ok, %{body: body, status_code: 200}} ->
        Jason.decode!(body)["data"]
      _ ->
        %{}
    end
  end

  def follow_currency(currency_id, user_details) when not is_nil(user_details) and currency_id in @cb_digital_currencies do

  end

  def unfollow_currency(currency_id, user_details) when not is_nil(user_details) and currency_id in @cb_digital_currencies do
    []
  end

  def enable_currency_alerts(currency_id, user_details, threshold, direction) when not is_nil(user_details) and currency_id in @cb_digital_currencies do
    []
  end

  def disable_currency_alerts(currency_id, user_details) when not is_nil(user_details) and currency_id in @cb_digital_currencies do
    []
  end

  def send_currency_alerts do
    nil
  end

end
