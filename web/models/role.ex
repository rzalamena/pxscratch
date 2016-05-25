defmodule Pxscratch.Role do
  use Pxscratch.Web, :model

  schema "roles" do
    field :name, :string
    field :description, :string
    field :admin, :boolean, default: false

    timestamps

    has_many :users, Pxscratch.User
  end

  @required_fields ~w(name admin)
  @optional_fields ~w(description)

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
  end
end
