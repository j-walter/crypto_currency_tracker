defmodule CryptoCurrencyTrackerWeb.RedirectController do
  use CryptoCurrencyTrackerWeb, :controller

  def index(conn, _params) do
    redirect(conn, to: "/")
  end

  def auth(conn, _params) do
    redirect(conn, to: "/auth/google")
  end

end