defmodule Pxscratch.Repo.Migrations.CreatePost do
  use Ecto.Migration

  def change do
    create table(:posts) do
      add :title, :text
      add :content, :text
      add :publish_date, :datetime
      add :comment_status, :integer
      add :password, :text
      add :page_url, :text
      add :user_id, references(:users)

      timestamps
    end
    create index(:posts, [:user_id])
    create unique_index(:posts, [:page_url])

  end
end
