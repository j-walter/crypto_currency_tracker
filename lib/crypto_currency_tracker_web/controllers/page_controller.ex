defmodule CryptoCurrencyTrackerWeb.PageController do
  use CryptoCurrencyTrackerWeb, :controller


  def index(conn, _params) do
    current_user = conn.assigns[:user]
    render(conn, "index.html", current_user: current_user)
  end
end
