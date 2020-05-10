defmodule PlayItCoolWeb.Resolvers.User do
  def list_users(_parent, _args, _resolution) do
    {:ok, [%{username: "ponasAdomas", email: "test@test.com", id: 1}]}
  end
end
