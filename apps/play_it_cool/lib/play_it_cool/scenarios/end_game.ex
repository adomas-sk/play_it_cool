defmodule PlayItCool.Scenarios.EndGame do
  import Ecto.Query

  alias PlayItCool.{Repo, Lobby, Event}

  def end_game(lobby_id, game_id, players) do
    lobby =
      from(l in Lobby, where: l.id == ^lobby_id)
      |> Repo.one()

    lobby
    |> Lobby.changeset(%{state: "WAITING"})
    |> Repo.update!()

    event_details =
      players
      |> Enum.map(fn player -> "player:#{player.id}_has_total_score_of:#{player.score}" end)
      |> Enum.join("-")

    %Event{}
    |> Event.changeset(%{
      event_type: "GAME_END",
      details: event_details,
      lobby_id: lobby_id,
      player_id: lobby.owner_id,
      game_id: game_id
    })
    |> Repo.insert()
  end
end
