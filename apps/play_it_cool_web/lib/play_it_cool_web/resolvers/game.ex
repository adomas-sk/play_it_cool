defmodule PlayItCoolWeb.Resolvers.Game do
  alias PlayItCool.Scenarios

  def create_lobby(_parent, user, _resolution) do
    Scenarios.CreateLobby.initialize(user)
  end

  def join_lobby(_parent, %{player_name: player_name, lobby_token: lobby_token}, _resolution) do
    Scenarios.JoinLobby.join_lobby(lobby_token, player_name)
  end
end
