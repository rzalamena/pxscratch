defmodule Pxscratch.UserController do
  use Pxscratch.Web, :controller

  alias Pxscratch.Role
  alias Pxscratch.User

  plug :scrub_params, "user" when action in [:create, :update]
  plug :authorize_sign_in when action in [:new, :create]
  plug :authorize_user when not action in [:new, :create]
  plug :authorize_admin when not action in [:new, :create, :edit, :update]

  def index(conn, _params) do
    users = Repo.all(User)
    render(conn, "index.html", users: users)
  end

  def new(conn, _params) do
    changeset = User.changeset(%User{})
    roles = Enum.map(Repo.all(Role), fn(x) ->
      { x.name, x.id }
    end)
    render(conn, "new.html", changeset: changeset, roles: roles)
  end

  def create(conn, %{"user" => user_params}) do
    # If user registration was not done by an admin, enforce the lowest
    # permission level.
    unless not is_nil(conn.assigns[:current_user]) and
      conn.assigns[:current_user].role.admin do
      user_params = Map.put(user_params, "role_id", 1)
    end

    changeset = User.changeset(%User{}, user_params)

    case Repo.insert(changeset) do
      {:ok, _user} ->
        conn
        |> put_flash(:info, "User created successfully.")
        |> redirect(to: page_path(conn, :index))
      {:error, changeset} ->
        roles = Enum.map(Repo.all(Role), fn(x) ->
          { x.name, x.id }
        end)
        render(conn, "new.html", changeset: changeset, roles: roles)
    end
  end

  def show(conn, %{"id" => id}) do
    user = Repo.get!(User, id)
    user = Repo.preload(user, :role)
    render(conn, "show.html", user: user)
  end

  def edit(conn, %{"id" => id}) do
    user = Repo.get!(User, id)
    changeset = User.changeset(user)
    roles = Enum.map(Repo.all(Role), fn(x) ->
      { x.name, x.id }
    end)
    render(conn, "edit.html", user: user, changeset: changeset, roles: roles)
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    user = Repo.get!(User, id)
    changeset = User.update_changeset(user, user_params)

    case Repo.update(changeset) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "User updated successfully.")
        |> redirect(to: user_path(conn, :show, user))
      {:error, changeset} ->
        roles = Enum.map(Repo.all(Role), fn(x) ->
          { x.name, x.id }
        end)
        render(conn, "edit.html", user: user, changeset: changeset, roles: roles)
    end
  end

  def delete(conn, %{"id" => id}) do
    user = Repo.get!(User, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(user)

    conn
    |> put_flash(:info, "User deleted successfully.")
    |> redirect(to: user_path(conn, :index))
  end

  def authorize_sign_in(conn, _params) do
    if Pxscratch.Setting.get_bvalue("public_sign_in", false) do
      conn
    else
      conn
      |> put_flash(:error, "Public registrations are not allowed now")
      |> redirect(to: page_path(conn, :index))
      |> halt
    end
  end
end
