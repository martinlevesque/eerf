defmodule Eerf.Auth.ErrorHandler do
  import Plug.Conn
  import Phoenix.Controller

  def auth_error(conn, {type, _reason}, _opts) do
    body = to_string(type)

    conn
    |> put_flash(:error, "Authentication invalid: #{body}")
    |> redirect(to: "/")
  end
end
