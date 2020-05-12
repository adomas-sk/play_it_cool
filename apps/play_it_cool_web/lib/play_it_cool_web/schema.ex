defmodule PlayItCoolWeb.Schema do
  use Absinthe.Schema
  import_types(PlayItCoolWeb.Types.User)
  import_types(PlayItCoolWeb.Types.Game)
  import_types(Absinthe.Type.Custom)

  alias PlayItCoolWeb.Resolvers

  query do
    @desc "Get all users"
    field :users, list_of(:user) do
      resolve(&Resolvers.User.list_users/3)
    end

    @desc "Get all subjects"
    field :subjects, list_of(:subject) do
      resolve(&Resolvers.Game.list_subjects/3)
    end
  end

  mutation do
    @desc "Create a lobby"
    field :create_lobby, :lobby_auth_token do
      arg(:id, :string)
      arg(:username, :string)

      resolve(&Resolvers.Game.create_lobby/3)
    end

    @desc "Join lobby"
    field :join_lobby, :lobby_auth_token do
      arg(:lobby_token, :integer)
      arg(:player_name, :string)

      resolve(&Resolvers.Game.join_lobby/3)
    end
  end
end
