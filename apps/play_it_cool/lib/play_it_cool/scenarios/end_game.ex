defmodule PlayItCool.Scenarios.EndGame do
  import Ecto.Query

  alias PlayItCool.{Repo, Lobby, Event}
  def end_game(lobby_id, game_id, scores) do
    IO.inspect lobby_id, label: "lobby_id"
    IO.inspect game_id, label: "game_id"
    IO.inspect scores, label: "scores"
    lobby =
      from(l in Lobby, where: l.id == ^lobby_id)
      |> Repo.one()
    lobby
    |> Lobby.changeset(%{state: "WAITING"})
    |> Repo.update!()

    event_details =
      scores
      |> Enum.map(fn {player_id, score} -> "player:#{player_id}_has_total_score_of:#{score}"end)
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
    |> IO.inspect(label: "game end event")
  end
end
