defmodule PlayItCool.Lobby do
  use Ecto.Schema

  import Ecto.Changeset

  schema "lobbies" do
    field :state, :string

    belongs_to :user, PlayItCool.User,
      foreign_key: :owner_id,
      references: :id

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:state, :owner_id])
    |> validate_required([:state, :owner_id])
  end
end
