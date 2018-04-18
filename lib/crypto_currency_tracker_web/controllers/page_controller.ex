defmodule CryptoCurrencyTrackerWeb.PageController do
  use CryptoCurrencyTrackerWeb, :controller


  def index(conn, _params) do
    render(conn, "index.html")
  end

  def bitcoin(conn, _params) do
    render(conn, "bitcoin.html")
  end

  def litecoin(conn, _params) do
    render(conn, "litecoin.html")
  end

  def ethereum(conn, _params) do
    render(conn, "ethereum.html")
  end

end
