defmodule Pxscratch.Repo.Migrations.CreateSetting do
  use Ecto.Migration

  def change do
    create table(:settings) do
      add :name, :text
      add :description, :text
      add :type, :text
      add :bvalue, :boolean, default: false
      add :ivalue, :integer
      add :fvalue, :float
      add :tvalue, :text

      timestamps
    end
    create unique_index(:settings, [:name])

  end
end
