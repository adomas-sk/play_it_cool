defmodule PlayItCool.Scenarios.Confirmation do
  alias PlayItCool.{Repo, Event}

  @spec confirm(any, any) :: :ok | {:error, <<_::112, _::_*24>>}
  def confirm(lobby_token, player_name) do
    case player_playing_it_cool?(player_name, lobby_token) do
      {:playing_it_cool, state, player} ->
        add_confirmation_event(state, player, "CONFIRM_COOL")
        |> send_update_to_game_lobby_process(lobby_token)

      {:knows_word, state, player} ->
        add_confirmation_event(state, player, "CONFIRM_WORD")
        |> send_update_to_game_lobby_process(lobby_token)

      {:error, error_message} ->
        {:error, error_message}
    end
  end

  defp player_playing_it_cool?(player_name, lobby_token) do
    case PlayItCool.GameLobby.get_game_state(Integer.to_string(lobby_token)) do
      %{players: players, current_game: current_game} = state ->
        case Enum.find(players, fn player -> player.name == player_name end) do
          nil ->
            {:error, "Player confirmation error: Player is not in the lobby"}

          current_player ->
            case current_game.playing_it_cool.name == current_player.name do
              true ->
                {:playing_it_cool, state, current_player}

              false ->
                {:knows_word, state, current_player}
            end
        end

      _state ->
        {:error, "Error occurred"}
    end
  end

  defp add_confirmation_event(
         %{current_game: current_game, lobby_id: lobby_id} = _state,
         %{id: player_id, name: player_name},
         event
       ) do
    %Event{}
    |> Event.changeset(%{
      event_type: event,
      game_id: current_game.id,
      lobby_id: lobby_id,
      player_id: player_id
    })
    |> Repo.insert!()

    player_name
  end

  defp send_update_to_game_lobby_process(player_name, lobby_token) do
    PlayItCool.GameLobby.confirm_player(Integer.to_string(lobby_token), player_name)
  end
end
