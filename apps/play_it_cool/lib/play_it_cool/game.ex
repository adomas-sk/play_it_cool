defmodule PlayItCool.Game do
  use Ecto.Schema

  import Ecto.Changeset

  schema "lobbies" do
    belongs_to :lobby, PlayItCool.Lobby,
      foreign_key: :lobby_id,
      references: :id

    belongs_to :subject, PlayItCool.Subject,
      foreign_key: :subject_id,
      references: :id

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:lobby_token, :lobby_id, :subject_id])
    |> validate_required([:lobby_token, :lobby_id, :subject_id])
  end
end
