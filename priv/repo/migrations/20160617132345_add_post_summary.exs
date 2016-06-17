defmodule Pxscratch.Repo.Migrations.AddPostSummary do
  use Ecto.Migration

  def change do
    alter table(:posts) do
      add :summary, :text
    end
  end
end
