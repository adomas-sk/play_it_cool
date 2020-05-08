defmodule PlayItCool.Repo.Migrations.CreatePlayers do
  use Ecto.Migration

  def change do
    create table(:players) do
      add :name, :string
      add :lobby_id, references(:lobbies)
      add :user_id, references(:users)

      timestamps()
    end
  end
end
