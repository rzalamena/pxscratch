defmodule Pxscratch.LayoutView do
  use Pxscratch.Web, :view

  alias Pxscratch.Repo
  alias Pxscratch.User

  def signed_in?(conn) do
    if Plug.Conn.get_session(conn, :current_user) do
      true
    else
      false
    end
  end

  def is_admin?(conn) do
    if current_user = Plug.Conn.get_session(conn, :current_user) do
      user = Repo.get(User, current_user.id)
      |> Repo.preload(:role)
      user.role.admin
    else
      false
    end
  end

  def current_user(conn) do
    if current_user = Plug.Conn.get_session(conn, :current_user) do
      Repo.get(User, current_user.id)
    else
      nil
    end
  end
end
