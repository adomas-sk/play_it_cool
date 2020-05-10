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
      players: [],
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
    {:noreply,
     Map.update(state, :players, state.players, fn existing_players ->
       [player | existing_players]
     end)}
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
      send_next_question(next_question)
      {:noreply, new_state}
    else
      {:noreply,
       Map.update(new_state, :current_game, new_state.current_game, fn game ->
         Map.put_new(game, :votes, [])
       end)}
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
      send_next_question(Enum.at(new_state.current_game.question_queue, 0))
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

        {:noreply, new_state}
    end
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
        IO.puts("Continue")
        {:noreply, state}
    end
  end

  defp get_reset_state(
         %{
           current_game:
             %{votes: votes, playing_it_cool: playing_it_cool, word: word, id: game_id} = _current_game,
           players: players,
           lobby_id: lobby_id,
           games: games
         } = state
       ) do
    IO.inspect(state)

    scores =
      players
      |> Enum.map(fn player ->
        case player.id == playing_it_cool.id do
          true ->
            score =
              get_score_of_player_who_was_playing_cool(votes, playing_it_cool, players, word)

            {player.id, score}

          false ->
            score = get_score_of_player_who_knew_the_word(votes, player, playing_it_cool)
            {player.id, score}
        end
      end)

    reset_state = %{
      players: Enum.map(players, fn p -> %{id: p.id, name: p.name} end),
      games: games,
      scores: get_next_scores(Map.has_key?(state, :scores), scores, votes)
    }
    PlayItCool.Scenarios.EndGame.end_game(lobby_id, game_id, reset_state.scores)

    {:noreply, reset_state}
  end

  defp get_next_scores(has_scores?, scores, votes) do
    case has_scores? do
      true ->
        scores
        |> Enum.map(fn {player_id, score} ->
          {_, prev_score} =
            votes
            |> Enum.find(fn v -> v.player_id == player_id end)

          {player_id, score + prev_score}
        end)

      false ->
        scores
    end
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

  defp send_next_question(%{questioneer: questioneer, question: question, answereer: answereer}) do
    IO.inspect(questioneer)
    IO.inspect(question)
    IO.inspect(answereer)

    IO.puts("SENDING QUESTION")
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
end