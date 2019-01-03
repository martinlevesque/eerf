defmodule Eerf.Rooms do
  @moduledoc """
  The Rooms context.
  """

  import Ecto.Query, warn: false
  alias Eerf.Repo

  alias Eerf.Rooms.Room

  @doc """
  Returns the list of rooms.

  ## Examples

      iex> list_rooms()
      [%Room{}, ...]

  """
  def list_rooms do
    Repo.all(Room)
  end

  def trending(my_limit) do
    Room
    |> order_by(desc: :nb_connected_users)
    |> limit(^my_limit)
    |> Repo.all
  end

  @doc """
  Gets a single room.

  Raises `Ecto.NoResultsError` if the Room does not exist.

  ## Examples

      iex> get_room!(123)
      %Room{}

      iex> get_room!(456)
      ** (Ecto.NoResultsError)

  """
  def get_room!(id), do: Repo.get!(Room, id)

  def get_room_or_create(name) do
    room = Repo.get_by(Room, name: name)

    cond do
      room -> room
      true ->
        {:ok, room} = create_room(%{ name: name, nb_connected_users: 0, elements: [] })
        room
    end
  end

  def get_room_by_name(name) do
     res = Repo.get_by(Room, name: name)
     IO.inspect res

     res
  end

  def update_elements(room, new_elem) do
    elements = room.elements

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

  @doc """
  Creates a room.

  ## Examples

      iex> create_room(%{field: value})
      {:ok, %Room{}}

      iex> create_room(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_room(attrs \\ %{}) do
    %Room{}
    |> Room.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a room.

  ## Examples

      iex> update_room(room, %{field: new_value})
      {:ok, %Room{}}

      iex> update_room(room, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_room(%Room{} = room, attrs) do
    room
    |> Room.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Room.

  ## Examples

      iex> delete_room(room)
      {:ok, %Room{}}

      iex> delete_room(room)
      {:error, %Ecto.Changeset{}}

  """
  def delete_room(%Room{} = room) do
    Repo.delete(room)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking room changes.

  ## Examples

      iex> change_room(room)
      %Ecto.Changeset{source: %Room{}}

  """
  def change_room(%Room{} = room) do
    Room.changeset(room, %{})
  end

  def has_keys_in_element?(element, keys) do
    Enum.all?(keys, fn k -> Map.has_key?(element, k) end)
  end

  def box_overlap_in_box?(elem1, elem2) do
    cond do
      elem1["x"] > elem2["x2"] || elem2["x"] > elem1["x2"] -> false
      elem1["y"] > elem2["y2"] || elem2["y"] > elem1["y2"] -> false
      true -> true
    end
  end

  def box_is_overlapping?(elem1, elem2) do
    cond do
      has_keys_in_element?(elem2, ["x", "y", "x2", "y2"]) ->
        box_overlap_in_box?(elem1, elem2)
      true -> false
    end
  end

  def is_element_valid?(%Room{} = room, "Restricted Space", message, socket) do
    # TODO
    IO.puts "message -_--> ? #{inspect message}"
    res = Enum.any?(room.elements, fn x ->
      IO.puts "xxx -> #{inspect x}"

      #x   x2

      #y   y2

      false
    end)

    IO.puts "res ? #{inspect res}"

    true
  end

  def is_element_valid?(%Room{} = room, tool, message, socket) do
    true
  end
end
