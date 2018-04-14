defmodule CryptoCurrencyTrackerWeb.AuthController do
  use CryptoCurrencyTrackerWeb, :controller
  alias CryptoCurrencyTracker.AuthAgent
  alias CryptoCurrencyTracker.ApiAgent
  alias CryptoCurrencyTracker.User

  plug Ueberauth

  def new(%{assigns: %{ueberauth_auth: auth}} = conn, _params) do
    conn = if Map.get(auth.extra.raw_info.user, "email_verified", false) do
      user = User.register_ueberauth_user(auth)
      AuthAgent.put(get_session(conn, "user_token"), user)
      put_session(conn, "user_auth", user)
    end
    conn
    |> Phoenix.Controller.redirect(to: "/")
  end

end
