defmodule CryptoCurrencyTrackerWeb.Router do
  use CryptoCurrencyTrackerWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :inject_token do
    plug CryptoCurrencyTrackerWeb.InjectToken
  end

  scope "/auth", CryptoCurrencyTrackerWeb do
    pipe_through :browser
    pipe_through :inject_token
    get "/:provider", AuthController, :request
    get "/:provider/callback", AuthController, :new
    get "/*path", RedirectController, :auth
  end

  scope "/", CryptoCurrencyTrackerWeb do
    pipe_through :browser # Use the default browser stack
    pipe_through :inject_token #
    get "/", PageController, :index
    get "/*path", RedirectController, :index
  end

end
