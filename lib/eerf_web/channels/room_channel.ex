defmodule EerfWeb.RoomChannel do
  use Phoenix.Channel
  alias EerfWeb.Presence
  alias Eerf.Auth

  defp get_room_name_from_socket(socket) do
    try do
      String.split(socket.topic, ":")
      |> List.last
    rescue
      x -> nil
    end
  end

  defp get_room_from_socket(socket) do
    room_name = get_room_name_from_socket(socket)

    Eerf.Rooms.get_room_or_create(room_name)
  end

  def join("room:" <> private_room_id, params, socket) do
    IO.puts "private room.. = #{private_room_id}"

    send(self(), :after_join)

    {:ok, socket}
  end

  defp presence_users_to_short_list(socket) do
     users = Presence.list(socket)

     Enum.map(Map.keys(users), fn uid ->
       first_meta = List.first(users[uid][:metas])

       case first_meta do
         nil -> nil
         _ -> %{ user_id: first_meta[:user_id], username: first_meta[:username] }
       end
     end)
     |> Enum.filter(fn item -> item end)
  end

  defp update_users(socket) do
    nb_users = length(Map.keys(Presence.list(socket)))

    room = get_room_from_socket(socket)
    Eerf.Rooms.update_room(room, %{nb_connected_users: nb_users})

    users_list = presence_users_to_short_list(socket)

    broadcast!(socket, "broadcast", %{
      type: "users_list",
      users_list: users_list
      })
  end

  defp leave_channel(socket) do
     Presence.untrack(socket, socket.assigns.user_id)
     update_users(socket)
  end

  def leave(socket, user_id) do
    leave_channel(socket)

    socket
  end

  def terminate(reason, socket) do
    leave_channel(socket)

    :ok
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

  def handle_info(:after_join, socket) do
    push(socket, "presence_state", Presence.list(socket))

    user = Auth.get_user!(socket.assigns.user_id)

    {:ok, _} = Presence.track(socket, user.id, %{
      online_at: inspect(System.system_time(:second)),
      user_id: user.id,
      username: user.username
    })

    update_users(socket)

    {:noreply, socket}
  end

  def handle_in("broadcast", message, socket) do
    try do
      broadcast!(socket, "broadcast", message)

      # save it in the proper room
      room = get_room_from_socket(socket)
      Eerf.Rooms.update_room(room, %{elements: update_room_elements(room.elements, message)})

      {:reply, :ok, socket}
    rescue
      x -> {:reply, {:error, "can't handle the msg - #{inspect x}"}, socket}
    end
  end
end
