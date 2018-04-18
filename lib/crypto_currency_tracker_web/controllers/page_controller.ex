defmodule CryptoCurrencyTrackerWeb.PageController do
  use CryptoCurrencyTrackerWeb, :controller


  def index(conn, _params) do
    render(conn, "index.html")
  end

end
