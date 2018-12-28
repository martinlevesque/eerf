defmodule Eerf.RestrictedSpacesTest do
  use Eerf.DataCase

  alias Eerf.RestrictedSpaces

  describe "restricted_spaces" do
    alias Eerf.RestrictedSpaces.RestrictedSpace

    @valid_attrs %{details: %{}}
    @update_attrs %{details: %{}}
    @invalid_attrs %{details: nil}

    def restricted_space_fixture(attrs \\ %{}) do
      {:ok, restricted_space} =
        attrs
        |> Enum.into(@valid_attrs)
        |> RestrictedSpaces.create_restricted_space()

      restricted_space
    end

    test "list_restricted_spaces/0 returns all restricted_spaces" do
      restricted_space = restricted_space_fixture()
      assert RestrictedSpaces.list_restricted_spaces() == [restricted_space]
    end

    test "get_restricted_space!/1 returns the restricted_space with given id" do
      restricted_space = restricted_space_fixture()
      assert RestrictedSpaces.get_restricted_space!(restricted_space.id) == restricted_space
    end

    test "create_restricted_space/1 with valid data creates a restricted_space" do
      assert {:ok, %RestrictedSpace{} = restricted_space} = RestrictedSpaces.create_restricted_space(@valid_attrs)
      assert restricted_space.details == %{}
    end

    test "create_restricted_space/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = RestrictedSpaces.create_restricted_space(@invalid_attrs)
    end

    test "update_restricted_space/2 with valid data updates the restricted_space" do
      restricted_space = restricted_space_fixture()
      assert {:ok, %RestrictedSpace{} = restricted_space} = RestrictedSpaces.update_restricted_space(restricted_space, @update_attrs)
      assert restricted_space.details == %{}
    end

    test "update_restricted_space/2 with invalid data returns error changeset" do
      restricted_space = restricted_space_fixture()
      assert {:error, %Ecto.Changeset{}} = RestrictedSpaces.update_restricted_space(restricted_space, @invalid_attrs)
      assert restricted_space == RestrictedSpaces.get_restricted_space!(restricted_space.id)
    end

    test "delete_restricted_space/1 deletes the restricted_space" do
      restricted_space = restricted_space_fixture()
      assert {:ok, %RestrictedSpace{}} = RestrictedSpaces.delete_restricted_space(restricted_space)
      assert_raise Ecto.NoResultsError, fn -> RestrictedSpaces.get_restricted_space!(restricted_space.id) end
    end

    test "change_restricted_space/1 returns a restricted_space changeset" do
      restricted_space = restricted_space_fixture()
      assert %Ecto.Changeset{} = RestrictedSpaces.change_restricted_space(restricted_space)
    end
  end
end
