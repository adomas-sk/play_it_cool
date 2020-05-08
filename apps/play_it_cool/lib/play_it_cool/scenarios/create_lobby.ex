defmodule PlayItCool.Scenarios.CreateLobby do
  @moduledoc """
    Lobby creation module, responsible for:
    * Creating a lobby in DB
    * Starting the process of the game lobby
    * Creating user as player in DB
    * Adding an event that player has joined the lobby
  """

  alias PlayItCool.{Lobby, Event, Player, Repo}

  @spec initialize(%{email: String.t(), username: String.t(), id: identifier()}) ::
          {:ok, Event} | {:error, any()}
  def initialize(user) do
    try do
      join_event =
        user
        |> create_lobby
        |> start_game_lobby
        |> add_user_as_player(user)
        |> add_join_event()

      {:ok, join_event}
    rescue
      errors ->
        set_lobby_state_to_error(errors)
        {:error, errors}
    end
  end

  defp create_lobby(%{id: user_id} = _) do
    %Lobby{}
    |> Lobby.changeset(%{owner_id: user_id, state: "INIT"})
    |> Repo.insert!()
  end

  defp add_user_as_player(
         %Lobby{id: lobby_id, owner_id: user_id} = lobby,
         %{username: username} = _
       ) do
    player =
      %Player{}
      |> Player.changeset(%{
        name: username,
        lobby_id: lobby_id,
        user_id: user_id
      })
      |> Repo.insert!()

    {lobby, player}
  end

  defp add_join_event({%Lobby{id: lobby_id}, %Player{id: player_id}}) do
    %Event{}
    |> Event.changeset(%{
      event_type: "JOIN_LOBBY",
      lobby_id: lobby_id,
      player_id: player_id
    })
    |> Repo.insert!()
  end

  defp start_game_lobby(%Lobby{lobby_token: lobby_token} = lobby) do
    PlayItCool.GameLobby.start_link(Integer.to_string(lobby_token))
    lobby
  end

  defp set_lobby_state_to_error(_errors) do
    # TODO: make this thing
    raise "Function not implemented"
  end
end
