defmodule Eerf.Repo.Migrations.CreateRooms do
  use Ecto.Migration

  def change do
    create table(:rooms) do
      add :name, :string
      add :nb_connected_users, :integer
      add :elements, {:array, :map}

      timestamps()
    end

  end
end
