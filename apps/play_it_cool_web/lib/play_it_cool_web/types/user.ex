defmodule PlayItCoolWeb.Types.User do
  use Absinthe.Schema.Notation

  # alias PlayItCoolWeb.Resolvers

  object :user do
    field(:id, :string)
    field(:email, :string)
    field(:username, :string)
  end
end
