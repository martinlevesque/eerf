defmodule EerfWeb.HomeController do
  use EerfWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
