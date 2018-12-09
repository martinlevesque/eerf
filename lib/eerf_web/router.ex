defmodule EerfWeb.Router do
  use EerfWeb, :router

  pipeline :auth do
    plug Eerf.Auth.Pipeline
  end

  pipeline :ensure_auth do
    plug Guardian.Plug.EnsureAuthenticated
  end

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
    pipe_through [:browser, :auth]

    get "/", HomeController, :index
  end

  scope "/user/", EerfWeb do
    pipe_through [:browser, :auth]

    post "/login", UserController, :login
    get "/register", UserController, :register
    post "/register", UserController, :do_register

    post "/logout", UserController, :logout
  end

  # Definitely logged in scope
  scope "/", EerfWeb do
    pipe_through [:browser, :auth, :ensure_auth]

    get "/home", HomeController, :home
    get "/at/:id", AtController, :index
    get "/find_room", HomeController, :find_room
  end

  # Other scopes may use custom stacks.
  # scope "/api", EerfWeb do
  #   pipe_through :api
  # end
end
