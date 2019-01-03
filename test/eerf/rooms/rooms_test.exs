defmodule Eerf.RoomsTest do
  use Eerf.DataCase

  alias Eerf.Rooms

  describe "rooms" do
    alias Eerf.Rooms.Room

    @valid_attrs %{elements: [], name: "some name", nb_connected_users: 42}
    @update_attrs %{elements: [], name: "some updated name", nb_connected_users: 43}
    @invalid_attrs %{elements: nil, name: nil, nb_connected_users: nil}

    def room_fixture(attrs \\ %{}) do
      {:ok, room} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Rooms.create_room()

      room
    end

    test "list_rooms/0 returns all rooms" do
      room = room_fixture()
      assert Rooms.list_rooms() == [room]
    end

    test "get_room!/1 returns the room with given id" do
      room = room_fixture()
      assert Rooms.get_room!(room.id) == room
    end

    test "create_room/1 with valid data creates a room" do
      assert {:ok, %Room{} = room} = Rooms.create_room(@valid_attrs)
      assert room.elements == []
      assert room.name == "some name"
      assert room.nb_connected_users == 42
    end

    test "create_room/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Rooms.create_room(@invalid_attrs)
    end

    test "update_room/2 with valid data updates the room" do
      room = room_fixture()
      assert {:ok, %Room{} = room} = Rooms.update_room(room, @update_attrs)
      assert room.elements == []
      assert room.name == "some updated name"
      assert room.nb_connected_users == 43
    end

    test "update_room/2 with invalid data returns error changeset" do
      room = room_fixture()
      assert {:error, %Ecto.Changeset{}} = Rooms.update_room(room, @invalid_attrs)
      assert room == Rooms.get_room!(room.id)
    end

    test "delete_room/1 deletes the room" do
      room = room_fixture()
      assert {:ok, %Room{}} = Rooms.delete_room(room)
      assert_raise Ecto.NoResultsError, fn -> Rooms.get_room!(room.id) end
    end

    test "change_room/1 returns a room changeset" do
      room = room_fixture()
      assert %Ecto.Changeset{} = Rooms.change_room(room)
    end

    test "box_is_overlapping?/2 with two non overlapping boxes" do

      first_box = %{
        "x" => 5,
        "x2" => 15,
        "y" => 2,
        "y2" => 10
      }

      other_box = %{
        "x" => 16,
        "x2" => 20,
        "y" => 2,
        "y2" => 10
      }

      assert false == Rooms.box_is_overlapping?(first_box, other_box)
    end

    test "box_is_overlapping?/2 with partially overlapping" do
      first_box = %{
        "x" => 5,
        "x2" => 15,
        "y" => 2,
        "y2" => 10
      }

      other_box = %{
        "x" => 7,
        "x2" => 17,
        "y" => 4,
        "y2" => 12
      }

      assert true == Rooms.box_is_overlapping?(first_box, other_box)
    end

    test "box_is_overlapping?/2 with two identical boxes" do

      first_box = %{
        "x" => 5,
        "x2" => 15,
        "y" => 2,
        "y2" => 10
      }

      second_box = %{
        "x" => 5,
        "x2" => 15,
        "y" => 2,
        "y2" => 10
      }

      assert true == Rooms.box_is_overlapping?(first_box, second_box)
    end

    test "has_keys_in_element?/2 with all keys" do
      first_box = %{
        "x" => 5,
        "x2" => 15,
        "y" => 2,
        "y2" => 10
      }

      assert true == Rooms.has_keys_in_element?(first_box, ["x", "x2", "y", "y2"])
    end

    test "has_keys_in_element?/2 with missing keys" do
      first_box = %{
        "x" => 5,
        "x2" => 15,
        "y" => 2
      }

      assert false == Rooms.has_keys_in_element?(first_box, ["x", "x2", "y", "y2"])
    end
  end
end
