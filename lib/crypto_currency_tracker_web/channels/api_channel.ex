defmodule CryptoCurrencyTrackerWeb.ApiChannel do

  use CryptoCurrencyTrackerWeb, :channel
  alias CryptoCurrencyTracker.Api
  alias CryptoCurrencyTracker.AuthAgent
  alias CryptoCurrencyTracker.User
  alias CryptoCurrencyTracker.Alert

  def join("api:", _payload, socket) do
    {:ok, Api.get_currency(nil, get_user_details(socket)), socket}
  end

  def handle_in("get_currency", %{"currency_id" => currency_id}, socket) do
    {:reply, {:ok, Api.get_currency(currency_id, get_user_details(socket))}, socket}
  end

  def handle_in("get_currency_pricing", %{"currency_id" => currency_id, "start_date" => start_date, "end_date" => end_date}, socket) do
    {:reply, {:ok, Api.get_currency_pricing(currency_id, start_date, end_date)}, socket}
  end

  #Should check what if user details are nil
  def handle_in("follow_currency", %{"currency_id" => currency_id}, socket) do
    user = Api.follow_currency(currency_id, get_user_details(socket))
    {:reply, {:ok, %{user: User.client_view(refresh_user_details(socket, user))}}, socket}
  end

  def handle_in("unfollow_currency", %{"currency_id" => currency_id}, socket) do
    user = Api.unfollow_currency(currency_id, get_user_details(socket))
    {:reply, {:ok, %{user: User.client_view(refresh_user_details(socket, user))}}, socket}
  end

  def handle_in("enable_currency_alerts", %{"currency_id" => currency_id, "thresholds" => thresholds}, socket) do
    thresholds = [get_float(thresholds["threshold1"]), get_float(thresholds["threshold2"])]
    {:reply, {:ok, %{alert: Alert.client_view(Api.enable_currency_alerts(currency_id, get_user_details(socket), thresholds))}}, socket}
  end

  defp get_float(num) do
    if is_number(num) do
      num / 1
    else
      {num, _} = Float.parse num
      num
    end
  end

  def handle_in("disable_currency_alerts", %{"currency_id" => currency_id}, socket) do
    {:reply, {:ok, %{alert: Alert.client_view(Api.disable_currency_alerts(currency_id, get_user_details(socket)))}}, socket}
  end

  defp refresh_user_details(socket, refreshed_user) when not is_nil(refreshed_user) do
    AuthAgent.put(socket.assigns[:user_token] || "", refreshed_user)
    refreshed_user
  end

  defp get_user_details(socket) do
    if !!socket.assigns[:user_token] and !!AuthAgent.get(socket.assigns[:user_token]) do
      AuthAgent.get(socket.assigns[:user_token])
    else
      nil
    end
  end

  def update_prices() do
    CryptoCurrencyTrackerWeb.Endpoint.broadcast "api", "update", Api.get_currency(nil, nil)
  end

end
