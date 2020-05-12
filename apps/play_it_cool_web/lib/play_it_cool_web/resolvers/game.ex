defmodule PlayItCoolWeb.Resolvers.Game do
  alias PlayItCool.Scenarios

  def create_lobby(_parent, user, _resolution) do
    case Scenarios.CreateLobby.initialize(user) do
      {:ok, lobby} ->
        {:ok,
         %{
           lobby_auth_token:
             Phoenix.Token.sign(PlayItCoolWeb.Endpoint, "user auth", %{
               lobby_token: lobby.lobby_token,
               player_name: user.username
             }),
           lobby_token: lobby.lobby_token,
           id: lobby.id
         }}

      {:error, message} ->
        {:error, message}
    end
  end

  def join_lobby(_parent, %{player_name: player_name, lobby_token: lobby_token}, _resolution) do
    case Scenarios.JoinLobby.join_lobby(lobby_token, player_name) do
      {:ok, lobby} ->
        {:ok,
         %{
           lobby_auth_token:
             Phoenix.Token.sign(PlayItCoolWeb.Endpoint, "user auth", %{
               lobby_token: lobby.lobby_token,
               player_name: player_name
             }),
           lobby_token: lobby.lobby_token,
           id: lobby.id
         }}

      {:error, message} ->
        {:error, message}
    end
  end

  def list_subjects(_parent, _params, _resolution) do
    {:ok, PlayItCool.Repo.all(PlayItCool.Subject)}
  end
end
