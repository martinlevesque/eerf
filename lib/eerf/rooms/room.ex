defmodule Eerf.Rooms.Room do
  use Ecto.Schema
  import Ecto.Changeset


  schema "rooms" do
    field :elements, {:array, :map}
    field :name, :string
    field :nb_connected_users, :integer

    timestamps()
  end

  @doc false
  def changeset(room, attrs) do
    room
    |> cast(attrs, [:name, :nb_connected_users, :elements])
    |> validate_required([:name, :nb_connected_users, :elements])
  end
end
