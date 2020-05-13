defmodule PlayItCool.Scenarios.AnswerQuestion do
  alias PlayItCool.{Repo, Event}

  @spec answer_question(integer(), String.t(), String.t()) :: :ok | {:error, any}
  def answer_question(lobby_token, question_id, player_id) do
    case question_in_lobby?(lobby_token, question_id, player_id) do
      {:error, message} ->
        {:error, message}

      {state, answereer} ->
        insert_answer_event(state.current_game.id, state.lobby_id, player_id, answereer)
        update_game_lobby_process(lobby_token, question_id)
    end
  end

  defp insert_answer_event(game_id, lobby_id, player_id, answereer) do
    %Event{}
    |> Event.changeset(%{
      event_type: "ASKED",
      details: "answereer_id:#{answereer.id},name:#{answereer.name}",
      game_id: game_id,
      lobby_id: lobby_id,
      player_id: player_id
    })
    |> Repo.insert()
  end

  defp update_game_lobby_process(lobby_token, question_id) do
    PlayItCool.GameLobby.answer_question(Integer.to_string(lobby_token), question_id)
  end

  defp question_in_lobby?(lobby_token, question_id, player_id) do
    case PlayItCool.GameLobby.get_game_state(Integer.to_string(lobby_token)) do
      %{current_game: %{question_queue: question_queue} = _game} = state ->
        case question_queue
             |> Enum.find(fn q -> !Map.has_key?(q, :answered) end) do
          %{questioneer: questioneer, question: question, answereer: answereer} ->
            cond do
              questioneer.id == player_id && question.id == question_id ->
                {state, answereer}

              true ->
                {:error, "Error occurred while answering question"}
            end

          _ ->
            {:error, "Question does not exist or is answered"}
        end

      {:error, message} ->
        {:error, message}

      _error ->
        {:error, "Error occurred while answering question"}
    end
  end
end
