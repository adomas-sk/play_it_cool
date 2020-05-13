defmodule PlayItCoolWeb.Resolvers.User do
  def list_users(_parent, _args, _resolution) do
    {:ok, [%{username: "testuser", email: "test@test.com", id: 1}]}
  end
end
