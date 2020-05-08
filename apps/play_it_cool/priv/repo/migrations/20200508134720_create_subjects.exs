defmodule PlayItCool.Repo.Migrations.CreateSubjects do
  use Ecto.Migration

  def change do
    create table(:subjects) do
      add :label, :string

      timestamps()
    end
  end
end
