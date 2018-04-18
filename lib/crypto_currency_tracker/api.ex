defmodule CryptoCurrencyTracker.Api do
  alias CryptoCurrencyTracker.ApiAgent
  alias CryptoCurrencyTracker.Api
  alias CryptoCurrencyTracker.Repo
  alias CryptoCurrencyTracker.User
  alias CryptoCurrencyTracker.Alert

  @digital_currencies ApiAgent.digital_currencies()


  # if currency_id is nil => return all the currency data that the active user is tracking
  # otherwise return the specific data associated with the requested currency id

  # if user details is nil
  def get_currency(currency_id, user_details) when is_nil(currency_id) or currency_id in @digital_currencies do
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
    #assuming data format right now
    #will only work with ISO86 Format
    start_date = Date.from_iso8601!(start_date)
    end_date = Date.from_iso8601!(end_date)
    diff = Date.diff(end_date, start_date)
    Enum.reduce(0..diff, %{}, fn i, acc ->
      date = Date.to_string(Date.add(start_date, i))
      Map.put(acc, date, ApiAgent.get_price_on(currency_id, date))
    end)
  end


  def follow_currency(currency_id, user_details) when not is_nil(user_details) and currency_id in @digital_currencies do
   change_user(Map.get(user_details, :id), "follow_#{currency_id}", true)
  end

  def unfollow_currency(currency_id, user_details) when not is_nil(user_details) and currency_id in @digital_currencies do
    change_user(Map.get((user_details), :id), "follow_#{currency_id}", false)
  end

  defp change_user(user_id, change_key, value) do
    Repo.get!(User, user_id)
    |> Ecto.Changeset.cast(%{change_key => value}, [String.to_atom(change_key)])
    |> Repo.update!
  end


  def enable_currency_alerts(currency_id, user_details, thresholds) when not is_nil(user_details) and currency_id in @digital_currencies do
    Alert.insert_or_update(currency_id, user_details, thresholds)
  end

  def disable_currency_alerts(currency_id, user_details) when not is_nil(user_details) and currency_id in @digital_currencies do
    Alert.delete(currency_id, user_details)
  end

  def client_view(model, user_details) do

  end

end
