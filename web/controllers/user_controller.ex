defmodule Pxscratch.UserController do
  use Pxscratch.Web, :controller

  alias Pxscratch.Role
  alias Pxscratch.Setting
  alias Pxscratch.User

  plug :scrub_params, "user" when action in [:create, :update]
  plug :authorize_user when not action in [:new, :create, :show]
  plug :authorize_admin when action in [:index, :delete]
  plug :authorize_sign_in when action in [:new, :create]
  plug :authorize_owner when action in [:edit, :update, :delete]

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
    if is_nil(conn.assigns[:current_user]) or
      not conn.assigns[:current_user].role.admin do
      user_params = Map.put(user_params, "role_id", Setting.get_ivalue("default_role"))
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

  defp authorize_owner(conn, _) do
    case load_user(conn) do
      {:ok, conn} ->
        user = conn.assigns[:current_user]
        if String.to_integer(conn.params["id"]) == user.id or user.role.admin do
          conn
        else
          conn
          |> put_flash(:error, "You can't edit others profile")
          |> redirect(to: page_path(conn, :index))
          |> halt
        end
      {:error, _} ->
        redirect_unauthorized(conn)
    end
  end
end
