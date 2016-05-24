defmodule Pxscratch.LayoutView do
  use Pxscratch.Web, :view

  def signed_in?(conn) do
    if Plug.Conn.get_session(conn, :current_user) do
      true
    else
      false
    end
  end
end
