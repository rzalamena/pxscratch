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

  def resume(text) do
    if is_nil(text) do
      ""
    else
      {text, _} = String.split_at(text, 32)
      text
    end
  end
end
