defmodule PlayItCool.Scenarios.CreateLobby do
  @moduledoc """
    Lobby creation module, responsible for:
    * Creating a lobby in DB
    * Starting the process of the game lobby
    * Creating user as player in DB
    * Adding an event that player has joined the lobby
  """

  alias PlayItCool.{Lobby, Event, Player, Repo}

  @spec initialize(%{
          email: String.t(),
          username: String.t(),
          id: identifier(),
          lowercase_username: String.t()
        }) ::
          {:ok, Lobby.t()} | {:error, any}
  def initialize(user) do
    try do
      lobby =
        user
        |> create_lobby
        |> start_game_lobby_process
        |> add_user_as_player(user)
        |> add_player_to_game_lobby_process
        |> add_create_and_join_events()

      {:ok, lobby}
    rescue
      errors ->
        set_lobby_state_to_error(errors)
        {:error, errors}
    end
  end

  defp create_lobby(%{id: user_id} = _) do
    %Lobby{}
    |> Lobby.changeset(Lobby.get_unique_lobby_token(%{owner_id: user_id, state: "INIT"}))
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

  defp add_create_and_join_events({%Lobby{id: lobby_id} = lobby, %Player{id: player_id}}) do
    %Event{}
    |> Event.changeset(%{
      event_type: "CREATE_LOBBY",
      lobby_id: lobby_id,
      player_id: player_id
    })
    |> Repo.insert!()

    %Event{}
    |> Event.changeset(%{
      event_type: "JOIN_LOBBY",
      lobby_id: lobby_id,
      player_id: player_id
    })
    |> Repo.insert!()

    lobby
  end

  defp start_game_lobby_process(%Lobby{lobby_token: lobby_token, id: lobby_id} = lobby) do
    PlayItCool.GameLobby.start_link(Integer.to_string(lobby_token), lobby_id)
    lobby
  end

  defp add_player_to_game_lobby_process(
         {%Lobby{lobby_token: lobby_token} = lobby, %Player{name: name, id: player_id} = player}
       ) do
    PlayItCool.GameLobby.add_player(%{id: player_id, name: name}, Integer.to_string(lobby_token))
    {lobby, player}
  end

  defp set_lobby_state_to_error(_errors) do
    # TODO: make this thing
    IO.inspect("Function not implemented")
  end
end
