defmodule PlayItCool.Player do
  use Ecto.Schema

  import Ecto.Changeset

  schema "players" do
    field :name, :string

    belongs_to :lobby, PlayItCool.Lobby,
      foreign_key: :lobby_id,
      references: :id

    belongs_to :user, PlayItCool.User,
      foreign_key: :user_id,
      references: :id

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:name, :lobby_id, :user_id])
    |> validate_required([:name, :lobby_id])
  end
end
