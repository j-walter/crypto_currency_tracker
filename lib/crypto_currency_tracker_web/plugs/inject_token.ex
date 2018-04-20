defmodule CryptoCurrencyTrackerWeb.InjectToken do
  @behaviour Plug
  import Plug.Conn

  def token_length, do: 64

  def init(default) do
    default
  end

  def call(conn, _default) do
    if !get_session(conn, "user_token"), do: put_session(conn, "user_token", :base64.encode(:crypto.strong_rand_bytes(token_length()))), else: conn
  end

end
