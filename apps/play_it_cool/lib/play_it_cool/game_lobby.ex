defmodule PlayItCool.GameLobby do
  @moduledoc """
    Game lobby process that will live as long as there are players

    TODO: Refactor, it's a mess
  """

  use GenServer

  @spec start_link(String.t(), String.t()) :: :ignore | {:error, any} | {:ok, pid}
  def start_link(lobby_token, lobby_id) do
    name = {:via, Registry, {Registry.GameLobbies, lobby_token}}

    init_state = %{
      lobby_id: lobby_id,
      lobby_token: lobby_token,
      players: [],
      scores: [],
      games: []
    }

    GenServer.start_link(__MODULE__, init_state, name: name, timeout: 1000 * 60)
  end

  @impl true
  @spec init(any) :: {:ok, any()}
  def init(state) do
    IO.puts("GenServer STARTED")

    {:ok, state}
  end

  @impl true
  def handle_cast({:add_player, player}, state) do
    player_with_scores =
      player
      |> Map.put_new(:score, 0)
      |> Map.put_new(:ready, true)

    new_state =
      if length(state.players) == 0 do
        state
        |> Map.update(:players, state.players, fn existing_players ->
          [player_with_scores | existing_players]
        end)
        |> Map.put_new(:lobby_master, player.id)
      else
        state
        |> Map.update(:players, state.players, fn existing_players ->
          [player_with_scores | existing_players]
        end)
      end

    safe_players =
      Enum.map(new_state.players, fn p ->
        {_, safe_player} = Map.pop(p, :token, nil)
        safe_player
      end)

    PlayItCoolWeb.Endpoint.broadcast(
      "lobby:#{state.lobby_token}",
      "player_update",
      %{players: safe_players}
    )

    {:noreply, new_state}
  end

  @impl true
  def handle_cast({:add_token, player_name, player_token}, state) do
    new_state =
      state
      |> Map.update(:players, state.players, fn existing_players ->
        Enum.map(existing_players, fn player ->
          if player.name == player_name && !Map.has_key?(player, :token) do
            Map.put_new(player, :token, player_token)
          else
            player
          end
        end)
      end)

    {:noreply, new_state}
  end

  @impl true
  def handle_cast({:player_ready, player_name}, %{players: players} = state) do
    new_players =
      players
      |> Enum.map(fn p ->
        if p.name == player_name do
          Map.put(p, :ready, true)
        else
          p
        end
      end)

    new_state =
      state
      |> Map.put(:players, new_players)

    PlayItCoolWeb.Endpoint.broadcast(
      "lobby:#{state.lobby_token}",
      "player_update",
      %{players: new_players}
    )

    {:noreply, new_state}
  end

  @impl true
  def handle_cast(
        {:vote_word, player_id, word},
        %{current_game: current_game} = state
      ) do
    new_current_game =
      current_game
      |> Map.update(:votes, current_game.votes, fn votes ->
        Enum.concat(votes, [%{player_id: player_id, voted_for_word: word}])
      end)

    new_state = Map.update(state, :current_game, state.current_game, fn _ -> new_current_game end)
    check_if_game_ended(new_state)
  end

  @impl true
  def handle_cast(
        {:vote_cool, player_id, player_name},
        %{current_game: current_game} = state
      ) do
    new_current_game =
      current_game
      |> Map.update(:votes, current_game.votes, fn votes ->
        Enum.concat(votes, [%{player_id: player_id, voted_who_played_cool: player_name}])
      end)

    new_state = Map.update(state, :current_game, state.current_game, fn _ -> new_current_game end)
    check_if_game_ended(new_state)
  end

  @impl true
  def handle_cast({:answer_question, question_id}, state) do
    new_state =
      state
      |> Map.update(:current_game, state.current_game, fn game ->
        Map.update(game, :question_queue, game.question_queue, fn queue ->
          Enum.map(queue, fn question ->
            case question.question.id == question_id do
              true ->
                Map.put_new(question, :answered, true)

              false ->
                question
            end
          end)
        end)
      end)

    next_question =
      Enum.find(new_state.current_game.question_queue, fn q -> !Map.has_key?(q, :answered) end)

    if next_question do
      send_next_question(next_question, state.lobby_token)
      {:noreply, new_state}
    else
      state_with_votes =
        new_state
        |> Map.update(:current_game, new_state.current_game, fn game ->
          Map.put_new(game, :votes, [])
        end)

      words_to_guess =
        [new_state.current_game.word | new_state.current_game.guessable_words]
        |> Enum.shuffle()

      PlayItCoolWeb.Endpoint.broadcast("lobby:#{new_state.lobby_token}", "vote", %{
        words: words_to_guess
      })

      {:noreply, state_with_votes}
    end
  end

  @impl true
  def handle_cast({:confirm_player, player_name}, state) do
    new_state =
      Map.update(state, :players, state.players, fn existing_players ->
        Enum.map(existing_players, fn player ->
          case player.name == player_name do
            true ->
              Map.put_new(player, :confirmed, true)

            false ->
              player
          end
        end)
      end)

    if Enum.all?(new_state.players, fn player -> Map.has_key?(player, :confirmed) end) do
      send_next_question(Enum.at(new_state.current_game.question_queue, 0), state.lobby_token)
    end

    {:noreply, new_state}
  end

  @impl true
  def handle_cast({:start_game, game_data}, state) do
    cond do
      Map.has_key?(state, :current_game) ->
        {:error, "Game is already in progress"}

      true ->
        playing_it_cool = Enum.random(state.players)

        full_game_data =
          game_data
          |> Map.put_new(:playing_it_cool, playing_it_cool)
          |> Map.put_new(
            :question_queue,
            create_question_queue(game_data.questions, state.players)
          )

        new_state =
          state
          |> Map.update(:games, state.games, fn past_games ->
            [%{id: full_game_data.id} | past_games]
          end)
          |> Map.put_new(:current_game, full_game_data)
          |> Map.update(:players, state.players, fn players ->
            players
            |> Enum.map(&Map.put(&1, :ready, false))
          end)

        PlayItCoolWeb.Endpoint.broadcast(
          "lobby:#{state.lobby_token}",
          "player_update",
          %{players: new_state.players}
        )

        send_words(
          new_state.players,
          new_state.current_game.playing_it_cool,
          new_state.current_game.word
        )

        {:noreply, new_state}
    end
  end

  defp send_words(players, playing_it_cool, word) do
    players
    |> Enum.each(fn player ->
      if player.id == playing_it_cool.id do
        PlayItCoolWeb.Endpoint.broadcast(
          "user:#{player.token}",
          "word",
          %{word: nil}
        )
      else
        PlayItCoolWeb.Endpoint.broadcast(
          "user:#{player.token}",
          "word",
          %{word: word}
        )
      end
    end)
  end

  @impl true
  def handle_call(:get_state, _from, state) do
    {:reply, state, state}
  end

  def check_if_game_ended(
        %{current_game: %{votes: votes} = _current_game, players: players} = state
      ) do
    cond do
      length(votes) == length(players) ->
        get_reset_state(state)

      true ->
        {:noreply, state}
    end
  end

  defp get_reset_state(
         %{
           current_game:
             %{votes: votes, playing_it_cool: playing_it_cool, word: word, id: game_id} =
               _current_game,
           players: players,
           lobby_id: lobby_id,
           games: games
         } = state
       ) do
    players_with_new_scores =
      players
      |> Enum.map(fn player ->
        {_, reset_player} = Map.pop(player, :confirmed, nil)

        case player.id == playing_it_cool.id do
          true ->
            score =
              get_score_of_player_who_was_playing_cool(votes, playing_it_cool, players, word)

            Map.update!(reset_player, :score, &(&1 + score))

          false ->
            score = get_score_of_player_who_knew_the_word(votes, player, playing_it_cool)
            Map.update!(reset_player, :score, &(&1 + score))
        end
      end)

    broadcast_game_ending(state.lobby_token, players_with_new_scores, playing_it_cool, word)

    reset_state = %{
      players: players_with_new_scores,
      lobby_master: state.lobby_master,
      lobby_id: state.lobby_id,
      lobby_token: state.lobby_token,
      games: games
    }

    PlayItCool.Scenarios.EndGame.end_game(lobby_id, game_id, players_with_new_scores)

    {:noreply, reset_state}
  end

  defp broadcast_game_ending(lobby_token, players_with_new_scores, playing_it_cool, word) do
    formatted_players =
      players_with_new_scores
      |> Enum.map(fn p ->
        {_, safe_player} = Map.pop(p, :token, nil)
        safe_player
      end)

    {_, formatted_player} = Map.pop(playing_it_cool, nil, :token)

    PlayItCoolWeb.Endpoint.broadcast(
      "lobby:#{lobby_token}",
      "ending",
      %{
        players: formatted_players,
        playingItCool: formatted_player,
        word: word
      }
    )
  end

  defp get_score_of_player_who_was_playing_cool(votes, playing_it_cool_player, players, word) do
    calculate_points_for_not_being_guessed(votes, playing_it_cool_player, players) +
      calculate_points_for_guessing_the_word(votes, playing_it_cool_player, word)
  end

  defp get_score_of_player_who_knew_the_word(votes, player, playing_it_cool_player) do
    vote =
      votes
      |> Enum.find(fn v -> v.player_id == player.id end)

    case vote.voted_who_played_cool == playing_it_cool_player.name do
      true -> 10
      false -> 0
    end
  end

  defp calculate_points_for_guessing_the_word(votes, playing_it_cool_player, word) do
    vote_guessing_the_word =
      votes
      |> Enum.find(fn v -> v.player_id == playing_it_cool_player.id end)

    case vote_guessing_the_word.voted_for_word == word do
      true -> 10
      false -> 0
    end
  end

  defp calculate_points_for_not_being_guessed(votes, playing_it_cool_player, players) do
    player_count_who_voted_right =
      votes
      |> Enum.filter(fn v ->
        Map.has_key?(v, :voted_who_played_cool) &&
          v.voted_who_played_cool == playing_it_cool_player.name
      end)
      |> length

    case player_count_who_voted_right > length(players) / 2 do
      true -> 0
      false -> 20
    end
  end

  defp send_next_question(
         %{questioneer: questioneer, question: question, answereer: answereer},
         lobby_token
       ) do
    {_, safe_questioneer} = Map.pop!(questioneer, :token)
    {_, safe_answereer} = Map.pop!(answereer, :token)

    PlayItCoolWeb.Endpoint.broadcast(
      "lobby:#{lobby_token}",
      "questioning",
      %{questioneer: safe_questioneer, answereer: safe_answereer, question: question}
    )
  end

  defp create_question_queue(questions, players) do
    shuffled_players = Enum.shuffle(players)
    questioneers = Enum.concat(shuffled_players, shuffled_players)
    [first | tail] = questioneers
    answereers = Enum.concat(tail, [first])

    questions
    |> Enum.with_index()
    |> Enum.map(fn {question, index} ->
      %{
        questioneer: Enum.at(questioneers, index),
        question: question,
        answereer: Enum.at(answereers, index)
      }
    end)
  end

  @spec find_game_lobby(String.t()) :: pid | {:error, String.t()}
  def find_game_lobby(lobby_token) do
    case Registry.lookup(Registry.GameLobbies, lobby_token) do
      [{pid, nil}] ->
        pid

      _ ->
        {:error, "Process not found"}
    end
  end

  @spec add_player(%{id: identifier(), name: String.t()}, String.t()) :: any()
  def add_player(player, lobby_token) do
    case find_game_lobby(lobby_token) do
      {:error, message} ->
        {:error, message}

      pid ->
        GenServer.cast(pid, {:add_player, player})
    end
  end

  def get_game_state(lobby_token) do
    case find_game_lobby(lobby_token) do
      {:error, message} ->
        {:error, message}

      pid ->
        GenServer.call(pid, :get_state)
    end
  end

  def start_new_game(game_data, lobby_token) do
    case find_game_lobby(lobby_token) do
      {:error, message} ->
        {:error, message}

      pid ->
        GenServer.cast(pid, {:start_game, game_data})
    end
  end

  def confirm_player(lobby_token, player_name) do
    case find_game_lobby(lobby_token) do
      {:error, message} ->
        {:error, message}

      pid ->
        GenServer.cast(pid, {:confirm_player, player_name})
    end
  end

  def answer_question(lobby_token, question_id) do
    case find_game_lobby(lobby_token) do
      {:error, message} ->
        {:error, message}

      pid ->
        GenServer.cast(pid, {:answer_question, question_id})
    end
  end

  def vote_what_the_word_was(lobby_token, player_id, word) do
    case find_game_lobby(lobby_token) do
      {:error, message} ->
        {:error, message}

      pid ->
        GenServer.cast(pid, {:vote_word, player_id, word})
    end
  end

  def vote_who_played_cool(lobby_token, player_id, player_name) do
    case find_game_lobby(lobby_token) do
      {:error, message} ->
        {:error, message}

      pid ->
        GenServer.cast(pid, {:vote_cool, player_id, player_name})
    end
  end

  def save_player_token(lobby_token, player_name, player_token) do
    case find_game_lobby(lobby_token) do
      {:error, message} ->
        {:error, message}

      pid ->
        GenServer.cast(pid, {:add_token, player_name, player_token})
    end
  end

  def set_player_as_ready(lobby_token, player_name) do
    case find_game_lobby(lobby_token) do
      {:error, message} ->
        {:error, message}

      pid ->
        GenServer.cast(pid, {:player_ready, player_name})
    end
  end
end
