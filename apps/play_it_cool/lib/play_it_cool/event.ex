defmodule PlayItCool.Event do
  use Ecto.Schema

  import Ecto.Changeset

  schema "events" do
		field :event_type, :string
		belongs_to :game, PlayItCool.Game,
      foreign_key: :game_id,
      references: :id
		belongs_to :player, PlayItCool.Player,
      foreign_key: :player_id,
      references: :id

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:event_type, :game_id, :player_id])
    |> validate_required([:state, :owner_id])
  end
end
