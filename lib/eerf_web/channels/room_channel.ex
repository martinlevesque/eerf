defmodule EerfWeb.RoomChannel do
  use Phoenix.Channel

  #def join("room:lobby", _message, socket) do
  #  {:ok, socket}
  #end

  def join("room:" <> private_room_id, params, socket) do
    IO.puts "private room.. = #{private_room_id}"
    IO.inspect params
    #{:error, %{reason: "unauthorized"}}
    {:ok, socket}
  end

  def handle_in("broadcast", message, socket) do
    IO.puts "broadcasted.."
    IO.inspect message
    broadcast!(socket, "broadcast", message)
    {:reply, :ok, socket}
  end
end
