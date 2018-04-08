defmodule CryptoCurrencyTrackerWeb.ApiChannel do

  use CryptoCurrencyTrackerWeb, :channel
  alias CryptoCurrencyTracker.Api

  def join("api:", _payload, socket) do
    cond do
      # one sock is assigned per user
      authenticated?(socket) ->
        {:ok, Api.get_currency(nil, socket.assigns[:user_details]), socket |> assign(:name, socket.assigns[:user_details])}
      true ->
        {:error, %{reason: "unauthorized"}}
    end
  end

  def handle_in("get_currency", %{"currency_id" => currency_id}, socket) do
    {:reply, {:ok, Api.get_currency(currency_id, socket.assigns[:user_details])}, socket}
  end

  def handle_in("get_currency_pricing", %{"currency_id" => currency_id, "start_date" => start_date, "end_date" => end_date}, socket) do
    {:reply, {:ok, Api.get_currency_pricing(currency_id, start_date, end_date)}, socket}
  end

  def handle_in("follow_currency", %{"currency_id" => currency_id}, socket) do
    {:reply, {:ok, Api.follow_currency(currency_id, socket.assigns[:user_details])}, socket}
  end

  def handle_in("unfollow_currency", %{"currency_id" => currency_id}, socket) do
    {:reply, {:ok, Api.unfollow_currency(currency_id, socket.assigns[:user_details])}, socket}
  end

  def handle_in("enable_currency_alerts", %{"currency_id" => currency_id, "threshold" => threshold, "direction" => direction}, socket) do
    {:reply, {:ok, Api.enable_currency_alerts(currency_id, socket.assigns[:user_details], threshold, direction)}, socket}
  end

  def handle_in("disable_currency_alerts", %{"currency_id" => currency_id}, socket) do
    {:reply, {:ok, Api.disable_currency_alerts(currency_id, socket.assigns[:user_details])}, socket}
  end

  defp authenticated?(socket) do
    !!Map.get(socket.assigns, :user_details, nil)
  end

end
