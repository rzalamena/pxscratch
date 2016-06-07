defmodule Pxscratch.User do
  use Pxscratch.Web, :model

  import Comeonin.Bcrypt, only: [hashpwsalt: 1]

  schema "users" do
    field :name, :string
    field :nickname, :string
    field :email, :string
    field :password_digest, :string

    timestamps

    field :password, :string, virtual: true
    belongs_to :role, Pxscratch.Role
    has_many :posts, Pxscratch.Post
  end

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, ~w(nickname email password role_id), ~w(name))
    |> validate_changeset
  end

  def update_changeset(model, params \\ :empty) do
    model
    |> cast(params, ~w(nickname email), ~w(name password role_id))
    |> validate_changeset
  end

  defp validate_changeset(changeset) do
    changeset
    |> unique_constraint(:nickname)
    |> unique_constraint(:email)
    |> foreign_key_constraint(:role_id)
    |> validate_length(:password, min: 8)
    |> validate_confirmation(:password)
    |> validate_length(:nickname, min: 4)
    |> validate_length(:nickname, max: 32)
    |> validate_length(:name, max: 255)
    |> validate_format(:email, ~r/\A[^@]+@[^@]+\z/)
    |> validate_length(:email, max: 255)
    |> digest_password
  end

  defp digest_password(changeset) do
    if password = get_change(changeset, :password) do
      put_change(changeset, :password_digest, hashpwsalt(password))
    else
      changeset
    end
  end
end
