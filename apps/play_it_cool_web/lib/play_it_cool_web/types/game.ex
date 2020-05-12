defmodule PlayItCoolWeb.Types.Game do
  use Absinthe.Schema.Notation

  # import_types(PlayItCoolWeb.Types.User)

  alias PlayItCoolWeb.Resolvers

  object :lobby do
    field(:id, :string)
    field(:state, :string)
    field(:lobby_token, :integer)

    field(:owner, :user) do
      # arg :id, :string
      # arg :email, :string
      # arg :username, :string
      resolve(&Resolvers.User.list_users/3)
    end
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
