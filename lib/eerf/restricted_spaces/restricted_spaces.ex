defmodule Eerf.RestrictedSpaces do
  @moduledoc """
  The RestrictedSpaces context.
  """

  import Ecto.Query, warn: false
  alias Eerf.Repo

  alias Eerf.RestrictedSpaces.RestrictedSpace

  @doc """
  Returns the list of restricted_spaces.

  ## Examples

      iex> list_restricted_spaces()
      [%RestrictedSpace{}, ...]

  """
  def list_restricted_spaces do
    Repo.all(RestrictedSpace)
  end

  @doc """
  Gets a single restricted_space.

  Raises `Ecto.NoResultsError` if the Restricted space does not exist.

  ## Examples

      iex> get_restricted_space!(123)
      %RestrictedSpace{}

      iex> get_restricted_space!(456)
      ** (Ecto.NoResultsError)

  """
  def get_restricted_space!(id), do: Repo.get!(RestrictedSpace, id)

  @doc """
  Creates a restricted_space.

  ## Examples

      iex> create_restricted_space(%{field: value})
      {:ok, %RestrictedSpace{}}

      iex> create_restricted_space(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_restricted_space(attrs \\ %{}) do
    %RestrictedSpace{}
    |> RestrictedSpace.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a restricted_space.

  ## Examples

      iex> update_restricted_space(restricted_space, %{field: new_value})
      {:ok, %RestrictedSpace{}}

      iex> update_restricted_space(restricted_space, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_restricted_space(%RestrictedSpace{} = restricted_space, attrs) do
    restricted_space
    |> RestrictedSpace.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a RestrictedSpace.

  ## Examples

      iex> delete_restricted_space(restricted_space)
      {:ok, %RestrictedSpace{}}

      iex> delete_restricted_space(restricted_space)
      {:error, %Ecto.Changeset{}}

  """
  def delete_restricted_space(%RestrictedSpace{} = restricted_space) do
    Repo.delete(restricted_space)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking restricted_space changes.

  ## Examples

      iex> change_restricted_space(restricted_space)
      %Ecto.Changeset{source: %RestrictedSpace{}}

  """
  def change_restricted_space(%RestrictedSpace{} = restricted_space) do
    RestrictedSpace.changeset(restricted_space, %{})
  end
end
