defmodule PlayItCool.Lobby do
  use Ecto.Schema

  import Ecto.Changeset

  schema "lobbies" do
    field :state, :string
    field :lobby_token, :integer

    belongs_to :user, PlayItCool.User,
      foreign_key: :owner_id,
      references: :id

    has_many :players, {"player", PlayItCool.Player}

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:state, :owner_id, :lobby_token])
    |> validate_required([:state, :owner_id, :lobby_token])
  end

  def get_unique_lobby_token(attrs) do
    token = Enum.random(100_000..999_999)
    Map.put(attrs, :lobby_token, token)
  end
end
