defmodule EerfWeb.HomeController do
  use EerfWeb, :controller

  plug :populate_init_user

  def index(conn, _params) do
    case conn.assigns[:maybe_user] do
      nil ->
        conn
          |> render("index.html", changeset: conn.assigns[:changeset],
            maybe_user: conn.assigns[:maybe_user],
            action: Routes.user_path(conn, :login))
      _ ->
        conn
        |> redirect(to: "/home")
    end
  end

  def home(conn, _params) do
    trending_rooms = Rooms.trending(5)

    render(conn, "home.html", trending_rooms: trending_rooms)
  end

  def find_room(conn, params) do
    room_name = params["room_name"]

    case Rooms.get_room_by_name(room_name) do
      nil ->
        changeset = Rooms.change_room(%Room{ name: room_name })

        conn
        |> render("edit_room.html", changeset: changeset, room_name: room_name,
          action: Routes.home_path(conn, :save_room))
      _ ->
        conn
        |> redirect(to: "/at/#{room_name}")
    end
  end

  def save_room(conn, params) do

  end
end
