defmodule Pxscratch.PageController do
  use Pxscratch.Web, :controller

  alias Pxscratch.Setting

  plug :authorize_user when action in [:settings, :save_setting]
  plug :authorize_admin when action in [:settings, :save_setting]

  def index(conn, _params) do
    render conn, "index.html"
  end

  def settings(conn, _params) do
    settings = Setting.get_all
    render conn, "settings.html", settings: settings
  end

  def save_setting(conn, %{"setting" => setting_params}) do
    setting = Repo.get_by!(Setting, name: setting_params["name"])
    changeset = Setting.update_changeset(setting, setting_params)
    case Repo.update(changeset) do
      {:ok, setting} ->
        conn
        |> redirect(to: page_path(conn, :settings))
      {:error, changeset} ->
        conn
        |> put_flash(:error, "Failed to save setting")
        |> redirect(to: page_path(conn, :settings))
    end
  end
end
