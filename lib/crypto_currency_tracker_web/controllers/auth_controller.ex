defmodule CryptoCurrencyTrackerWeb.AuthController do
  use CryptoCurrencyTrackerWeb, :controller
  alias CryptoCurrencyTracker.AuthAgent

  plug Ueberauth

  def new(%{assigns: %{ueberauth_auth: auth}} = conn, _params) do
    conn = if Map.get(auth.extra.raw_info.user, "email_verified", false) do
      AuthAgent.put(get_session(conn, "user_token"), auth)
      put_session(conn, "user_auth", auth)
    end
    conn
    |> Phoenix.Controller.redirect(to: "/")
  end

end
