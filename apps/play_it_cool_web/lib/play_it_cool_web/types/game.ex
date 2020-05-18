defmodule PlayItCoolWeb.Types.Game do
  use Absinthe.Schema.Notation

  object :lobby do
    field(:id, :string)
    field(:state, :string)
    field(:lobby_token, :integer)
  end

  object :lobby_auth_token do
    field(:lobby_auth_token, :string)
    field(:id, :string)
    field(:lobby_token, :integer)
  end

  object :subject do
    field(:id, :string)
    field(:label, :string)

    field(:words, :string) do
      {:ok, ["apple"]}
    end
  end
end
