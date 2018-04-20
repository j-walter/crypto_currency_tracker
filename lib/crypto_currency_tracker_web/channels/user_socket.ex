defmodule CryptoCurrencyTrackerWeb.UserSocket do
  use Phoenix.Socket

  channel "api:*", CryptoCurrencyTrackerWeb.ApiChannel
  transport :websocket, Phoenix.Transports.WebSocket
  alias CryptoCurrencyTrackerWeb.InjectToken

  def connect(params, socket) do
    if !!params["token"] do
      {:ok, assign(socket, :user_token, params["token"])}
    else
      {:error}
    end
  end

  def id(socket), do: "users_socket: #{socket.assigns.user_token}"
end
