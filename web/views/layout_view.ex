defmodule Pxscratch.LayoutView do
  use Pxscratch.Web, :view

  def signed_in?(conn) do
    case load_user(conn) do
      {:ok, _} -> true
      {:error, _} -> false
    end
  end

  def is_admin?(conn) do
    case load_user(conn) do
      {:ok, conn} ->
        user = conn.assigns[:current_user]
        user.role.admin
      {:error, _} -> false
    end
  end

  def current_user(conn) do
    case load_user(conn) do
      {:ok, conn} -> conn.assigns[:current_user]
      {:error, _} -> nil
    end
  end

  def get_page_title do
    Pxscratch.Setting.get_tvalue("website_name")
  end
end
