defmodule PlayItCoolWeb.Schema do
  use Absinthe.Schema
  import_types PlayItCoolWeb.Types.User
  import_types Absinthe.Type.Custom

  alias PlayItCoolWeb.Resolvers

  query do
    # @desc "Login"
    # field :login, :token do
    #   arg :email, non_null(:string)
    #   arg :password, non_null(:string)
    #   resolve &Resolvers.User.login/3
    # end

    @desc "Get all users"
    field :users, list_of(:user) do
      resolve &Resolvers.User.list_users/3
    end

  end
end
