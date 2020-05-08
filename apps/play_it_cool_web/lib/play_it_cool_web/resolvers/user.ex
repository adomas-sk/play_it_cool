defmodule PlayItCoolWeb.Resolvers.User do
  def list_users(_parent, _args, _resolution) do
    {:ok, [%{name: "Jonas"}]}
  end
end
