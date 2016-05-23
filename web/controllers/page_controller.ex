defmodule Pxscratch.PageController do
  use Pxscratch.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
