defmodule PlayItCool.Repo.Migrations.CreateLobbies do
  use Ecto.Migration

  def change do
    create table(:lobbies) do
      add :state, :string
      add :owner_id, references(:users)

      timestamps()
    end
  end
end
