defmodule PlayItCool.Scenarios.CloseLobby do
  import Ecto.Query

  alias PlayItCool.{Repo, Lobby, Event}

  def close_lobby(lobby_token) do
    lobby_token
    |> find_lobby()
    |> change_lobby_state()
    |> add_lobby_closed_event()
  end

  defp find_lobby(lobby_token) do
    from(l in Lobby,
      where: l.lobby_token == ^lobby_token,
      where: l.state in ["WAITING", "INIT", "PLAYING"]
    )
    |> Repo.one()
  end

  defp change_lobby_state(lobby) do
    update =
      lobby
      |> Lobby.changeset(%{state: "CLOSED"})
      |> Repo.update()

    case update do
      {:error, _} ->
        raise "Error closing lobby"

      {:ok, new_lobby} ->
        new_lobby
    end
  end

  defp add_lobby_closed_event(lobby) do
    %Event{}
    |> Event.changeset(%{
      event_type: "LOBBY_CLOSED",
      lobby_id: lobby.id,
      player_id: lobby.owner_id
    })
    |> Repo.insert()
  end
end
