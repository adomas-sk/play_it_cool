defmodule PlayItCool.Scenarios.JoinLobby do
  @moduledoc """
  Module used to add player to an existing lobby
  """
  import Ecto.Query

  alias PlayItCool.{Lobby, Event, Player, Repo}

  @spec join_lobby(any, any) :: {:ok, Lobby.t()} | {:error, any}
  def join_lobby(lobby_token, player_name) do
    case fetch_lobby(lobby_token) do
      {:error, error_message} ->
        {:error, error_message}

      lobby ->
        lobby
        |> player_name_exists_in_lobby(player_name)
        |> add_player(player_name)
        |> add_join_event()
        |> add_player_to_game_lobby_process()

        {:ok, lobby}
    end
  end

  defp add_player(%Lobby{id: lobby_id} = lobby, name) do
    player =
      %Player{}
      |> Player.changeset(%{name: name, lobby_id: lobby_id})
      |> Repo.insert!()

    {lobby, player}
  end

  defp add_join_event(
         {%Lobby{id: lobby_id, lobby_token: lobby_token}, %Player{id: player_id} = player}
       ) do
    %Event{}
    |> Event.changeset(%{event_type: "JOIN_LOBBY", lobby_id: lobby_id, player_id: player_id})
    |> Repo.insert!()

    {player, lobby_token}
  end

  defp add_player_to_game_lobby_process({%Player{id: id, name: name}, lobby_token}) do
    PlayItCool.GameLobby.add_player(%{id: id, name: name}, Integer.to_string(lobby_token))
  end

  defp fetch_lobby(lobby_token) do
    case from(lobby in Lobby, where: lobby.lobby_token == ^lobby_token)
         |> Repo.one() do
      nil ->
        {:error, "No lobby with this token"}

      lobby ->
        lobby
    end
  end

  defp player_name_exists_in_lobby(%Lobby{id: lobby_id} = lobby, player_name) do
    case from(player in Player,
           where: player.name == ^player_name,
           where: player.lobby_id == ^lobby_id
         )
         |> Repo.one() do
      nil ->
        lobby

      _ ->
        raise "Player name already exists in this lobby"
    end
  end
end
