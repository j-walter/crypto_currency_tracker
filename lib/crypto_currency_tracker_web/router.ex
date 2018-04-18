defmodule CryptoCurrencyTrackerWeb.Router do
  use CryptoCurrencyTrackerWeb, :router

  pipeline :browser do
    plug(:accepts, ["html"])
    plug(:fetch_session)
    plug :get_user
    plug(:fetch_flash)
    plug(:protect_from_forgery)
    plug(:put_secure_browser_headers)
  end

  # followed nat's lecture 12 notes for plugs and this link for conn: https://devhints.io/phoenix-conn
  def get_user(conn, _params) do
    IO.inspect(conn |> get_req_header("authorization"))

    if length(conn |> get_req_header("authorization")) > 0 do
      [token] = conn |> get_req_header("authorization")
      {resp, user_id} = Phoenix.Token.verify(conn, "user_token", token, [])
      user = Users.get_user!(user_id)
      conn |> assign(:user, user)
    else
      conn |> assign(:user, nil)
    end
  end

  pipeline :api do
    plug(:accepts, ["json"])
  end

  pipeline :inject_token do
    plug(CryptoCurrencyTrackerWeb.InjectToken)
  end

  scope "/auth", CryptoCurrencyTrackerWeb do
    pipe_through :browser
    pipe_through :inject_token
    get "/:provider", AuthController, :request
    get "/:provider/callback", AuthController, :new
    get "/*path", RedirectController, :auth
  end

  scope "/", CryptoCurrencyTrackerWeb do
    # Use the default browser stack
    pipe_through(:browser)
    #
    pipe_through(:inject_token)
    get "/", PageController, :index
    get("/*path", RedirectController, :index)
  end

  if Mix.env == :dev do
    forward "/sent_emails", Bamboo.EmailPreviewPlug
  end

end
