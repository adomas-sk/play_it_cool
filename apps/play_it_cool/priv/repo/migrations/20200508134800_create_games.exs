defmodule PlayItCool.Repo.Migrations.CreateGames do
  use Ecto.Migration

  def change do
    create table(:games) do
      add :game_token, :string
      add :lobby_id, references(:lobbies)
      add :subject_id, references(:subjects)

      timestamps()
    end
  end
end
