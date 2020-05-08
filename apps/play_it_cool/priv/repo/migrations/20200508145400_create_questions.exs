defmodule PlayItCool.Repo.Migrations.CreateQuestions do
  use Ecto.Migration

  def change do
    create table(:questions) do
      add :question, :string
      add :subject_id, references(:subjects)
    end
  end
end
