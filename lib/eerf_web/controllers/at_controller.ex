defmodule EerfWeb.AtController do
  use EerfWeb, :controller
  plug :put_layout, "at.html"

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
