defmodule Eerf.Repo.Migrations.CreateRestrictedSpaces do
  use Ecto.Migration

  def change do
    create table(:restricted_spaces) do
      add :details, :map
      add :user_id, references(:users, on_delete: :nothing)
      add :room_id, references(:rooms, on_delete: :nothing)

      timestamps()
    end

    create index(:restricted_spaces, [:user_id])
    create index(:restricted_spaces, [:room_id])
  end
end
