defmodule Pxscratch.Plugs do
  import Phoenix.Controller
  import Pxscratch.Router.Helpers
  import Plug.Conn

  alias Pxscratch.User
  alias Pxscratch.Repo

  def authorize_user(conn, _) do
    if current_user = get_session(conn, :current_user) do
      if Repo.get(User, current_user.id) do
        conn
      else
        redirect_unauthorized(conn)
      end
    else
      redirect_unauthorized(conn)
    end
  end

  defp redirect_unauthorized(conn) do
    conn
    |> put_flash(:error, "Unauthorized")
    |> redirect(to: page_path(conn, :index))
    |> halt
  end
end
