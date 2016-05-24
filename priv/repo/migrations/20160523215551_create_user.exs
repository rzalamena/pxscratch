defmodule Pxscratch.Repo.Migrations.CreateUser do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :name, :text
      add :nickname, :text
      add :email, :text
      add :password_digest, :text

      timestamps
    end
    create unique_index(:users, [:nickname])
    create unique_index(:users, [:email])

  end
end
