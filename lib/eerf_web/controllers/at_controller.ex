defmodule EerfWeb.AtController do
  use EerfWeb, :controller
  plug :put_layout, "at.html"
  plug :populate_init_user

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
