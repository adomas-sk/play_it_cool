defmodule PlayItCool.Scenarios.Vote do
  alias PlayItCool.{Repo, Event}

  @spec vote(any, any, any) :: :ok | {:error, <<_::136, _::_*80>>}
  def vote(lobby_token, player_id, vote) do
    case player_playing_it_cool?(lobby_token, player_id) do
      true ->
        vote_what_the_word_was(lobby_token, player_id, vote)

      false ->
        vote_who_played_cool(lobby_token, player_id, vote)

      {:error, message} ->
        {:error, message}
    end
  end

  defp vote_who_played_cool(lobby_token, player_id, player_name) do
    lobby_state = PlayItCool.GameLobby.get_game_state(Integer.to_string(lobby_token))

    add_a_vote_event(
      lobby_state.current_game.id,
      lobby_state.lobby_id,
      player_id,
      "VOTE_WHO_PLAYED_COOL",
      player_name
    )

    PlayItCool.GameLobby.vote_who_played_cool(
      Integer.to_string(lobby_token),
      player_id,
      player_name
    )
  end

  defp vote_what_the_word_was(lobby_token, player_id, word) do
    lobby_state = PlayItCool.GameLobby.get_game_state(Integer.to_string(lobby_token))

    add_a_vote_event(
      lobby_state.current_game.id,
      lobby_state.lobby_id,
      player_id,
      "VOTE_WHAT_THE_WORD_WAS",
      word
    )

    PlayItCool.GameLobby.vote_what_the_word_was(Integer.to_string(lobby_token), player_id, word)
  end

  defp add_a_vote_event(game_id, lobby_id, player_id, event_type, picked) do
    %Event{}
    |> Event.changeset(%{
      event_type: event_type,
      details: picked,
      game_id: game_id,
      lobby_id: lobby_id,
      player_id: player_id
    })
    |> Repo.insert()
  end

  defp player_playing_it_cool?(lobby_token, player_id) do
    case PlayItCool.GameLobby.get_game_state(Integer.to_string(lobby_token)) do
      %{current_game: %{playing_it_cool: player} = _game} ->
        player_id == player.id

      _ ->
        {:error, "Error occurred while voting"}
    end
  end
end
