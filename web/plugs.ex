defmodule Pxscratch.Plugs do
  import Phoenix.Controller
  import Pxscratch.Router.Helpers
  import Plug.Conn

  alias Pxscratch.User
  alias Pxscratch.Repo

  def authorize_user(conn, _) do
    case load_user(conn) do
      {:ok, conn} ->
        conn
      {:error, _} ->
        redirect_unauthorized(conn)
    end
  end

  def authorize_admin(conn, _) do
    case load_user(conn) do
      {:ok, conn} ->
        user = conn.assigns[:current_user]
        if user.role.admin do
          conn
        else
          redirect_unauthorized(conn)
        end
      {:error, _} ->
        redirect_unauthorized(conn)
    end
  end

  def authorize_sign_in(conn, params) do
    if Pxscratch.Setting.get_bvalue("public_sign_in", false) do
      conn
    else
      authorize_admin(conn, params)
    end
  end

  defp redirect_unauthorized(conn) do
    conn
    |> put_flash(:error, "Unauthorized")
    |> redirect(to: page_path(conn, :index))
    |> halt
  end

  defp assign_user(conn) do
    if current_user = get_session(conn, :current_user) do
      if user = Repo.get(User, current_user.id) do
        user = Repo.preload(user, :role)
        conn = assign(conn, :current_user, user)
        {:ok, conn}
      else
        {:error, conn}
      end
    else
      {:error, conn}
    end
  end

  defp load_user(conn) do
    if conn.assigns[:current_user] do
      {:ok, conn}
    else
      assign_user(conn)
    end
  end
end
