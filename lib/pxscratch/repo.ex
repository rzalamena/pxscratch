defmodule Pxscratch.Repo do
  use Ecto.Repo, otp_app: :pxscratch
  use Scrivener, page_size: 10
end
