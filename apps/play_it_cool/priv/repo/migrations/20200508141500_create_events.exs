defmodule PlayItCool.Repo.Migrations.CreateEvents do
  use Ecto.Migration

  def change do
    create table(:events) do
      add :event_type, :string
      add :game_id, references(:games)
      add :player_id, references(:players)

      timestamps()
    end
  end
end
