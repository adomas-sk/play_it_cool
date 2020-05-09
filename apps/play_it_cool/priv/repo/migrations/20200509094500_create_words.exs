defmodule PlayItCool.Repo.Migrations.CreateWords do
  use Ecto.Migration

  def change do
    create table(:words) do
      add :word, :string
      add :subject_id, references(:subjects)

      timestamps()
    end
  end
end
