defmodule Pxscratch.Repo.Migrations.CreateRole do
  use Ecto.Migration

  def change do
    create table(:roles) do
      add :name, :text
      add :description, :text
      add :admin, :boolean, default: false

      timestamps
    end

    alter table(:users) do
      add :role_id, references(:roles)
    end
    create index(:users, [:role_id])
  end
end
