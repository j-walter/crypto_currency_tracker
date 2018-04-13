defmodule CryptoCurrencyTrackerWeb.ApiChannel do

  use CryptoCurrencyTrackerWeb, :channel
  alias CryptoCurrencyTracker.Api
  alias CryptoCurrencyTracker.AuthAgent

  def join("api:", _payload, socket) do
      {:ok, Api.get_currency(nil, get_user_details(socket)), socket}
  end

  def handle_in("get_currency", %{"currency_id" => currency_id}, socket) do
    {:reply, {:ok, Api.get_currency(currency_id, get_user_details(socket))}, socket}
  end

  def handle_in("get_currency_pricing", %{"currency_id" => currency_id, "start_date" => start_date, "end_date" => end_date}, socket) do
    {:reply, {:ok, Api.get_currency_pricing(currency_id, start_date, end_date)}, socket}
  end

  def handle_in("follow_currency", %{"currency_id" => currency_id}, socket) do
    {:reply, {:ok, Api.follow_currency(currency_id, get_user_details(socket))}, socket}
  end

  def handle_in("unfollow_currency", %{"currency_id" => currency_id}, socket) do
    {:reply, {:ok, Api.unfollow_currency(currency_id, get_user_details(socket))}, socket}
  end

  def handle_in("enable_currency_alerts", %{"currency_id" => currency_id, "thresholds" => thresholds}, socket) do
    {:reply, {:ok, Api.enable_currency_alerts(currency_id, get_user_details(socket), thresholds, direction)}, socket}
  end

  def handle_in("disable_currency_alerts", %{"currency_id" => currency_id}, socket) do
    {:reply, {:ok, Api.disable_currency_alerts(currency_id, get_user_details(socket))}, socket}
  end

  defp get_user_details(socket) do
    if !!socket.assigns[:user_token] and !!AuthAgent.get(socket.assigns[:user_token]) do
      AuthAgent.get(socket.assigns[:user_token])
    else
      nil
    end
  end

end
