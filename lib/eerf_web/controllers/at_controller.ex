defmodule EerfWeb.AtController do
  use EerfWeb, :controller
  plug :put_layout, "at.html"
  plug :populate_init_user

  def index(conn, params) do
    case Rooms.get_room_by_name(params["id"]) do
      nil -> conn |> redirect(to: Routes.home_path(conn, :find_room, room_name: params["id"]))
      _ -> conn |> render("index.html")
    end
  end
end
