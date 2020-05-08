defmodule PlayItCool.Event do
  use Ecto.Schema

  import Ecto.Changeset

  schema "events" do
    field :event_type, :string
    field :details, :string

    belongs_to :game, PlayItCool.Game,
      foreign_key: :game_id,
      references: :id

    belongs_to :lobby, PlayItCool.Lobby,
      foreign_key: :lobby_id,
      references: :id

    belongs_to :player, PlayItCool.Player,
      foreign_key: :player_id,
      references: :id

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:event_type, :lobby_id, :game_id, :player_id, :details])
    |> validate_required([:event_type, :lobby_id, :player_id])
  end
end
