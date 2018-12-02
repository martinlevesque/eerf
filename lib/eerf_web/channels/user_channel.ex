defmodule EerfWeb.UserChannel do
  use Phoenix.Channel

  #def join("room:lobby", _message, socket) do
  #  {:ok, socket}
  #end

  def join("user:" <> private_id, params, socket) do
    IO.puts "private user.. = #{private_id}"
    #{:error, %{reason: "unauthorized"}}
    {:ok, socket}
  end

  def handle_in("get-board", %{"board_name" => board_name}, socket) do
    board_data = %{ "im": "data" }
    broadcast!(socket, "broadcast", %{board_data: board_data})
    {:reply, :ok, socket}
  end
end
