defmodule PlayItCool.Usecases.CreateLobby do
  alias PlayItCool.{Lobby, Event, Player, Repo}

  def initialize(user) do
    try do
      user
      |> create_lobby
      |> add_user_as_player(user)
      |> add_join_event()
    rescue
      errors ->
        IO.inspect(errors, label: "Error while creating lobby")
    end
  end

  defp create_lobby(%{id: user_id} = _) do
    %Lobby{}
    |> Lobby.changeset(%{owner_id: user_id, state: "INIT"})
    |> Repo.insert!()
  end

  defp add_user_as_player(%Lobby{id: lobby_id, owner_id: user_id} = lobby, %{username: username} = _) do
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
end
