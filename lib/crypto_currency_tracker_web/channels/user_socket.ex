defmodule CryptoCurrencyTrackerWeb.UserSocket do
  use Phoenix.Socket
  alias CryptoCurrencyTracker.AuthAgent

  channel "api:*", CryptoCurrencyTrackerWeb.ApiChannel
  transport :websocket, Phoenix.Transports.WebSocket

  def connect(params, socket) do
    if !!AuthAgent.get(Map.get(params, "token", nil)) do
      {:ok, assign(socket, :user_details, AuthAgent.get(params["token"]).extra.raw_info.user)}
    else
      {:ok, assign(socket, :user_details, nil)}
    end
  end

  def id(socket), do: "users_socket: #{socket.assigns.user_details["email"]}"
end
