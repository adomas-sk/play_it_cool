defmodule PlayItCoolWeb.Types.User do
  use Absinthe.Schema.Notation

  # alias PlayItCoolWeb.Resolvers

  object :user do
    field(:id, :string)
    field(:email, :string)
    field(:username, :string)
  end

  object :login do
    field(:user, :user)
    field(:token, :string)
  end
end
