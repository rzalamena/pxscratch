defmodule Pxscratch.Setting do
  use Pxscratch.Web, :model

  import Ecto.Query, only: [from: 2]
  alias Pxscratch.Setting
  alias Pxscratch.Repo

  schema "settings" do
    field :name, :string
    field :description, :string
    field :type, :string
    field :bvalue, :boolean, default: false
    field :ivalue, :integer
    field :fvalue, :float
    field :tvalue, :string

    timestamps
  end

  @required_fields ~w(name description type)
  @optional_fields ~w(bvalue ivalue fvalue tvalue)

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
    |> unique_constraint(:name)
  end

  def update_changeset(model, params \\ :empty) do
    model
    |> cast(params, ~w(), ~w(bvalue ivalue fvalue tvalue))
    |> unique_constraint(:name)
  end

  def get_all do
    q = from s in Setting, order_by: s.name
    Repo.all(q)
  end

  def get_bvalue(name, default \\ false) do
    q = from s in Setting,
      where: ilike(s.name, ^name)
    case Repo.one(q) do
      nil ->
        default
      r ->
        r.bvalue
    end
  end

  def get_tvalue(name, default \\ "") do
    q = from s in Setting,
      where: ilike(s.name, ^name)
    case Repo.one(q) do
      nil ->
        default
      r ->
        r.tvalue
    end
  end
end
