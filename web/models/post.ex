defmodule Pxscratch.Post do
  use Pxscratch.Web, :model

  schema "posts" do
    field :title, :string
    field :content, :string
    field :publish_date, Ecto.DateTime
    field :comment_status, :integer, default: 0
    field :password, :string
    field :page_url, :string
    belongs_to :user, Pxscratch.User

    timestamps

    field :publish, :boolean, virtual: true
    field :protect, :boolean, virtual: true
  end

  @required_fields ~w(user_id)
  @optional_fields ~w(title content comment_status publish publish_date page_url protect password)

  def new_changeset(model, params \\ %{}) do
    if model.publish_date do
      params = Map.put(params, :publish, true)
    end
    if model.password do
      params = Map.put(params, :protect, true)
    end
    model
    |> cast(params, @required_fields, @optional_fields)
    |> validate_changeset
  end

  def changeset(model, params \\ %{}) do
    model
    |> cast(params, @required_fields, @optional_fields)
    |> validate_changeset
  end

  defp validate_changeset(changeset) do
    changeset
    |> unique_constraint(:page_url)
    |> validate_page_url
    |> validate_publish
    |> validate_password
  end

  defp validate_page_url(changeset) do
    if get_field(changeset, :page_url) do
      changeset
      |> validate_format(:page_url, ~r/\a[a-zA-Z0-9-]+\Z/)
    else
      if title = get_field(changeset, :title) do
        changeset
        |> put_change(:page_url, Slugger.slugify_downcase(title))
      else
        changeset
      end
    end
  end

  defp validate_publish(changeset) do
    if get_change(changeset, :publish) do
      changeset
    else
      changeset
      |> put_change(:publish_date, nil)
    end
  end

  defp validate_password(changeset) do
    if get_change(changeset, :protect) do
      changeset
    else
      changeset
      |> put_change(:password, nil)
    end
  end

  defp is_published_now(model) do
    now = Ecto.DateTime.utc()
    if Ecto.DateTime.compare(now, model.publish_date) == :gt do
      true
    else
      false
    end
  end

  def is_published(model) do
    if is_nil(model.publish_date) do
      false
    else
      is_published_now(model)
    end
  end

  def is_authenticated(model, password) do
    if is_nil(model.password) do
      true
    else
      if model.password == password do
        true
      else
        false
      end
    end
  end
end
