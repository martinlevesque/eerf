defmodule EerfWeb.HomeController do
  use EerfWeb, :controller

  plug :populate_init_user

  def index(conn, _params) do
    case conn.assigns[:maybe_user] do
      nil ->
        conn
          |> render("index.html", changeset: conn.assigns[:changeset],
            maybe_user: conn.assigns[:maybe_user],
            action: Routes.home_path(conn, :login))
      _ ->
        conn
        |> redirect(to: "/home")
    end
  end

  def login(conn, %{"user" => %{"username" => username, "password" => password}}) do
    Auth.authenticate_user(username, password)
    |> login_reply(conn)
  end

  def register(conn, _params) do
    changeset = Auth.change_user(%User{})

    conn
      |> render("register.html", changeset: changeset,
        action: Routes.home_path(conn, :do_register))
  end

  def do_register(conn, %{"user" => user}) do
    case Auth.create_user(user) do
      {:ok, _} ->
        conn
        |> put_flash(:success, "User created successfully!")
        |> redirect(to: "/")
      {:error, changeset} ->
        conn
        |> put_flash(:error, "Could not save the user successfully")
        |> render("register.html", changeset: changeset,
          action: Routes.home_path(conn, :do_register), errors: changeset.errors)
    end
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
    |> redirect(to: "/home")
  end

  def logout(conn, _) do
    conn
    |> Guardian.Plug.sign_out()
    |> redirect(to: "/")
  end

  def home(conn, _params) do
    render(conn, "home.html")
  end

  defp populate_init_user(conn, _) do
    {changeset, maybe_user} = check_auth_user(conn)

    conn
    |> assign(:changeset, changeset)
    |> assign(:maybe_user, maybe_user)
  end
end
