defmodule Pxscratch.LayoutView do
  use Pxscratch.Web, :view

  alias Pxscratch.Repo
  alias Pxscratch.User

  def signed_in?(conn) do
    case load_user(conn) do
      {:ok, conn} -> true
      {:error, conn} -> false
    end
  end

  def is_admin?(conn) do
    case load_user(conn) do
      {:ok, conn} ->
        user = conn.assigns[:current_user]
        user.role.admin
      {:error, conn} -> false
    end
  end

  def current_user(conn) do
    case load_user(conn) do
      {:ok, conn} -> conn.assigns[:current_user]
      {:error, conn} -> nil
    end
  end

  def get_page_title do
    Pxscratch.Setting.get_tvalue("website_name")
  end
end
