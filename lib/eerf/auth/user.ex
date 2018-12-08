defmodule Eerf.Auth.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias Comeonin.Bcrypt


  schema "users" do
    field :email, :string
    field :password, :string
    field :username, :string

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:username, :password, :email])
    |> unique_constraint(:email)
    |> unique_constraint(:username)
    |> validate_length(:password, min: 8)
    |> validate_required([:username, :password, :email])
    |> put_pass_hash()
  end

  defp put_pass_hash(%Ecto.Changeset{valid?: true, changes: %{password: password}} = changeset) do
    change(changeset, password: Bcrypt.hashpwsalt(password))
  end

  defp put_pass_hash(changeset), do: changeset
end
