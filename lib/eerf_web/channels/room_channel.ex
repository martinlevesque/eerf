defmodule EerfWeb.RoomChannel do
  use Phoenix.Channel

  defp get_room_name_from_socket(socket) do
    try do
      String.split(socket.topic, ":")
      |> List.last
    rescue
      x -> nil
    end
  end

  def join("room:" <> private_room_id, params, socket) do
    IO.puts "private room.. = #{private_room_id}"
    IO.inspect params
    
    {:ok, socket}
  end

  defp update_room_elements(elements, new_elem) do

    has_elem_with_update_type =
      Enum.any?(elements, fn x -> x["id"] == new_elem["id"] && x["type"] == "update" end)

    cond do
      # DELETE
      new_elem["type"] == "delete" ->
        Enum.filter(elements, fn x ->
          new_elem["id"] != x["id"] && new_elem["id"] != x["parent"]
        end)
      # Update type, doesn't exist
      new_elem["type"] == "update" && ! has_elem_with_update_type ->
        elements ++ [new_elem]
      # Update type, exists
      new_elem["type"] == "update" ->
        Enum.map(elements, fn x ->
          cond do
            x["id"] == new_elem["id"] && x["type"] == new_elem["type"] ->
              new_elem
            true -> x
          end
        end)
      # NEW element
      true -> elements ++ [new_elem]
    end
  end

  def handle_in("broadcast", message, socket) do
    try do
      broadcast!(socket, "broadcast", message)

      # save it in the proper room
      room_name = get_room_name_from_socket(socket)

      room = Eerf.Rooms.get_room_or_create(room_name)
      Eerf.Rooms.update_room(room, %{elements: update_room_elements(room.elements, message)})

      {:reply, :ok, socket}
    rescue
      x -> {:reply, {:error, "can't handle the msg - #{inspect x}"}, socket}
    end
  end
end
