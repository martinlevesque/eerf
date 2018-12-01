defmodule EerfWeb.Router do
  use EerfWeb, :router

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

  scope "/", EerfWeb do
    pipe_through :browser

    get "/", HomeController, :index
    get "/at/:id", AtController, :index
  end

  # Other scopes may use custom stacks.
  # scope "/api", EerfWeb do
  #   pipe_through :api
  # end
end
