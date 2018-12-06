defmodule EerfWeb.HomeController do
  use EerfWeb, :controller
  alias EerfWeb.Router.Helpers, as: Routes

  alias Eerf.Auth
  alias Eerf.Auth.User
  alias Eerf.Auth.Guardian

  def index(conn, _params) do
    changeset = Auth.change_user(%User{})
    maybe_user = Guardian.Plug.current_resource(conn)

    conn
      |> render("index.html", changeset: changeset,
        maybe_user: maybe_user,
        action: Routes.home_path(conn, :login))
  end

  def login(conn, %{"user" => %{"username" => username, "password" => password}}) do
    Auth.authenticate_user(username, password)
    |> login_reply(conn)
  end

  defp login_reply({:error, error}, conn) do
    conn
    |> put_flash(:error, error)
    |> redirect(to: "/")
  end

  defp login_reply({:ok, user}, conn) do
    conn
    |> put_flash(:success, "Welcome back!")
    |> Guardian.Plug.sign_in(user)
    |> redirect(to: "/")
  end

  def logout(conn, _) do
    conn
    |> Guardian.Plug.sign_out()
    |> redirect(to: Routes.home_path(conn, :login))
  end

  def home(conn, _params) do
    render(conn, "home.html")
  end
end
