defmodule Eerf.RestrictedSpaces.RestrictedSpace do
  use Ecto.Schema
  import Ecto.Changeset

  schema "restricted_spaces" do
    field :details, :map, default: %{}
    belongs_to :user, Eerf.Auth.User
    belongs_to :room, Eerf.Rooms.Room

    timestamps()
  end

  @doc false
  def changeset(restricted_space, attrs) do
    restricted_space
    |> cast(attrs, [:details])
    |> validate_required([:details])
  end
end
