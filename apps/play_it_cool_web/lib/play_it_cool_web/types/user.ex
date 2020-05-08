defmodule PlayItCoolWeb.Types.User do
  use Absinthe.Schema.Notation

  alias PlayItCoolWeb.Resolvers

  object :user do
    field :name, :string
  end
end
