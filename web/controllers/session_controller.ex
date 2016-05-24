defmodule Pxscratch.SessionController do
  use Pxscratch.Web, :controller

  import Comeonin.Bcrypt, only: [checkpw: 2]

  alias Pxscratch.User

  plug :already_logged_in when action in [:new, :create]
  plug :scrub_params, "user" when action in [:create]

  def new(conn, _) do
    render conn, "new.html", changeset: User.changeset(%User{})
  end

  def create(conn, %{ "user" => %{ "email" => email, "password" => password } }) when
      is_binary(email) and is_binary(password) do
    user = Repo.get_by(User, email: email)
    if not is_nil(user) and checkpw(password, user.password_digest) do
      conn
      |> put_session(:current_user, %{ id: user.id })
      |> put_flash(:info, "Welcome back")
      |> redirect(to: page_path(conn, :index))
    else
      login_fail(conn)
    end
  end

  def create(conn, params) do
    login_fail(conn)
  end

  def delete(conn, _) do
    conn
    |> put_session(:current_user, nil)
    |> put_flash(:info, "We hope to see you back soon")
    |> redirect(to: page_path(conn, :index))
  end

  defp login_fail(conn) do
    conn
    |> put_session(:current_user, nil)
    |> put_flash(:error, "Invalid login credentials")
    |> redirect(to: session_path(conn, :new))
    |> halt
  end

  defp already_logged_in(conn, _) do
    if user = Plug.Conn.get_session(conn, :current_user) do
      conn
      |> put_flash(:error, "You are already logged in")
      |> redirect(to: page_path(conn, :index))
      |> halt
    else
      conn
    end
  end
end
