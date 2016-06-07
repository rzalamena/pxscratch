defmodule Pxscratch.PostView do
  use Pxscratch.Web, :view

  def select_comment_status(f, opts \\ []) do
    select(f, :comment_status, [
      "Allowed": 0,
      "Prohibited": 1,
      "Review": 2,
    ], opts)
  end
end
