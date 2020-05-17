defmodule PlayItCoolWeb.Schema do
  use Absinthe.Schema
  import_types(PlayItCoolWeb.Types.User)
  import_types(PlayItCoolWeb.Types.Game)
  import_types(Absinthe.Type.Custom)

  alias PlayItCoolWeb.Resolvers

  query do
    @desc "Get all subjects"
    field :subjects, list_of(:subject) do
      resolve(&Resolvers.Game.list_subjects/3)
    end
  end

  mutation do
    @desc "Create a lobby"
    field :create_lobby, :lobby_auth_token do
      resolve(&Resolvers.Game.create_lobby/3)
    end

    @desc "Join lobby"
    field :join_lobby, :lobby_auth_token do
      arg(:lobby_token, non_null(:integer))
      arg(:player_name, non_null(:string))

      resolve(&Resolvers.Game.join_lobby/3)
    end

    @desc "Register"
    field :register, :user do
      arg(:email, non_null(:string))
      arg(:username, non_null(:string))
      arg(:password, non_null(:string))

      resolve(&Resolvers.User.register/3)
    end

    @desc "Login"
    field :login, :login do
      arg(:email, non_null(:string))
      arg(:password, non_null(:string))

      resolve(&Resolvers.User.login/3)
    end
  end
end
