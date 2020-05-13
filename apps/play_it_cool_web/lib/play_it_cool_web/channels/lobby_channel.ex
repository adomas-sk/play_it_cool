defmodule PlayItCoolWeb.LobbyChannel do
  use Phoenix.Channel

  def join("lobby:" <> lobby_token, %{"token" => token}, socket) do
    {:ok, %{lobby_token: descrypted_lobby_token, player_name: player_name}} =
      Phoenix.Token.verify(PlayItCoolWeb.Endpoint, "user auth", token, max_age: 864_000)

    unless descrypted_lobby_token == lobby_token do
      {:error, %{reason: "Invalid token"}}
    end

    case PlayItCool.GameLobby.get_game_state(lobby_token) do
      {:error, message} ->
        {:error, %{reason: message}}

      lobby_state ->
        case Enum.find(lobby_state.players, fn p -> p.name == player_name end) do
          nil ->
            {:error, %{reason: "Invalid token"}}

          _ ->
            send(self(), {:after_join, lobby_token, player_name, token})

            safe_to_send_players = Enum.map(lobby_state.players, &remove_player_token/1)

            if Map.has_key?(lobby_state, :current_game) do
              {:ok, format_info(lobby_state, safe_to_send_players), socket}
            else
              {:ok, format_initial_info(lobby_state, safe_to_send_players), socket}
            end
        end
    end
  end

  def join("user:" <> user_id, _params, socket) do
    case Phoenix.Token.verify(PlayItCoolWeb.Endpoint, "user auth", user_id, max_age: 864_000) do
      {:ok, _decrypted_data} ->
        {:ok, socket}

      _ ->
        {:error, %{reason: "Invalid token"}}
    end
  end

  def handle_in("start_game", %{"topic" => topic}, socket) do
    "lobby:" <> lobby_token = socket.topic
    PlayItCool.Scenarios.StartGame.start_game(lobby_token, topic)

    {:noreply, socket}
  end

  def handle_in("confirmation", %{"token" => token}, socket) do
    case Phoenix.Token.verify(PlayItCoolWeb.Endpoint, "user auth", token, max_age: 864_000) do
      {:ok, token_data} ->
        PlayItCool.Scenarios.Confirmation.confirm(
          token_data.lobby_token,
          token_data.player_name
        )

        {:noreply, socket}

      _ ->
        {:error, %{reason: "Invalid token"}}
    end
  end

  def handle_in("answer", %{"token" => token, "questionId" => question_id}, socket) do
    case Phoenix.Token.verify(PlayItCoolWeb.Endpoint, "user auth", token, max_age: 864_000) do
      {:ok, token_data} ->
        case PlayItCool.GameLobby.get_game_state(Integer.to_string(token_data.lobby_token)) do
          {:error, _message} ->
            {:error, %{reason: "Invalid message"}}

          lobby_state ->
            player =
              lobby_state.players
              |> Enum.find(fn p -> p.name === token_data.player_name end)

            PlayItCool.Scenarios.AnswerQuestion.answer_question(
              token_data.lobby_token,
              question_id,
              player.id
            )

            {:noreply, socket}
        end
    end
  end

  def handle_in("vote", %{"token" => token, "vote" => vote}, socket) do
    case Phoenix.Token.verify(PlayItCoolWeb.Endpoint, "user auth", token, max_age: 864_000) do
      {:ok, token_data} ->
        case PlayItCool.GameLobby.get_game_state(Integer.to_string(token_data.lobby_token)) do
          {:error, _message} ->
            {:error, %{reason: "Invalid message"}}

          lobby_state ->
            player =
              lobby_state.players
              |> Enum.find(fn p -> p.name === token_data.player_name end)

            PlayItCool.Scenarios.Vote.vote(
              token_data.lobby_token,
              player.id,
              vote
            )

            {:noreply, socket}
        end
    end
  end

  def handle_info({:after_join, lobby_token, player_name, player_token}, socket) do
    PlayItCool.GameLobby.save_player_token(lobby_token, player_name, player_token)

    {:noreply, socket}
  end

  defp remove_player_token(player) do
    {_, safe_to_send_player} =
      player
      |> Map.pop(:token, nil)

    safe_to_send_player
  end

  defp format_initial_info(state, players) do
    {scores, _} = Map.pop(state, :scores, [])

    formatted_scores =
      scores
      |> Enum.map(fn {player_id, score} -> %{playerId: player_id, score: score} end)

    %{
      players: players,
      lobbyMaster: state.lobby_master,
      scores: formatted_scores
    }
  end

  defp format_info(state, players) do
    players
    |> Enum.each(fn p ->
      if Map.has_key?(p, :token) do
        if p.id == state.current_game.playing_it_cool.id do
          PlayItCoolWeb.Endpoint.broadcast(
            "user:#{p.token}",
            "word",
            %{word: nil}
          )
        else
          PlayItCoolWeb.Endpoint.broadcast("user:#{p.token}", "word", %{
            word: state.current_game.word
          })
        end
      end
    end)

    case Enum.find(state.current_game.question_queue, &(!Map.has_key?(&1, :answered))) do
      %{questioneer: questioneer, answereer: answereer, question: question} ->
        %{
          players: players,
          lobbyMaster: state.lobby_master,
          questioneer: remove_player_token(questioneer),
          answereer: remove_player_token(answereer),
          question: question
        }

      _ ->
        words =
          [state.current_game.word | state.current_game.guessable_words]
          |> Enum.shuffle()

        %{
          players: players,
          lobbyMaster: state.lobby_master,
          votingStarted: true,
          words: words
        }
    end
  end
end
