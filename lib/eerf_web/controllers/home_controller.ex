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

    # TODO refactor with rooms controller

    IO.puts "params === #{inspect params}"
    room_name = params["room_name"]
    IO.inspect room_name

    case Rooms.get_room_by_name(room_name) do
      nil ->
        changeset = Rooms.change_room(%Room{})

        conn
        |> render("new_room.html", changeset: changeset)
      _ ->
        conn
        |> redirect(to: "/at/#{room_name}")
    end
  end
end
