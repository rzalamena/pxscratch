defmodule Pxscratch.PostView do
  use Pxscratch.Web, :view

  import Scrivener.HTML
  import Pxscratch.LayoutView, only: [signed_in?: 1]

  def select_comment_status(f, opts \\ []) do
    select(f, :comment_status, [
      "Allowed": 0,
      "Prohibited": 1,
      "Review": 2,
    ], opts)
  end

  def markdown(text) do
    text
    |> Earmark.to_html
    |> raw
  end
end
