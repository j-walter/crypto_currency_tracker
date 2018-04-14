defmodule CryptoCurrencyTracker.Api do
  alias CryptoCurrencyTracker.ApiAgent
  alias CryptoCurrencyTracker.Api

  @digital_currencies ApiAgent.digital_currencies()


  # if currency_id is nil => return all the currency data that the active user is tracking
  # otherwise return the specific data associated with the requested currency id

  # if user details is nil
  def get_currency(currency_id, user_details) do
    if user_details  do
      if currency_id in @digital_currencies do
        %{currency_id => ApiAgent.get(currency_id)}
      else
        prices = %{}
        Enum.reduce(@digital_currencies, prices, fn currency, prices ->
          if Map.get(user_details, String.to_atom("follow_" <> currency))do
            Map.put(prices, currency, ApiAgent.get(currency))
          else 
            prices
          end
        end)
      end
    else
      if currency_id in @digital_currencies do
        %{currency_id => ApiAgent.get(currency_id)}
      else 
        prices = %{}
        Enum.reduce(@digital_currencies, prices, fn currency, prices ->
          Map.put(prices, currency, ApiAgent.get(currency))
        end)
      end 
    end
  end

  def get_currency_pricing(currency_id, start_date, end_date) when currency_id in @digital_currencies do

  end

  def follow_currency(currency_id, user_details) when not is_nil(user_details) and currency_id in @digital_currencies do
    
  end

  def unfollow_currency(currency_id, user_details) when not is_nil(user_details) and currency_id in @digital_currencies do
    []
  end


  def enable_currency_alerts(currency_id, user_details, thresholds) when not is_nil(user_details) and currency_id in @digital_currencies do
    []
  end

  def disable_currency_alerts(currency_id, user_details) when not is_nil(user_details) and currency_id in @digital_currencies do
    []
  end



  def send_currency_alerts do
    nil
  end

end
