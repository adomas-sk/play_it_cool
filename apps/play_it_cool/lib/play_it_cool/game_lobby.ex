defmodule PlayItCool.GameLobby do
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
        %{current_game: current_game, players: players} = state
      ) do
    new_current_game =
      current_game
      |> Map.update(:votes, current_game.votes, fn votes ->
        Enum.concat(votes, [%{player_id: player_id, voted_for_word: word}])
      end)

    new_state = Map.update(state, :current_game, state.current_game, fn _ -> new_current_game end)
    check_if_game_ended(new_state, players)
  end

  @impl true
  def handle_cast(
        {:vote_cool, player_id, player_name},
        %{current_game: current_game, players: players} = state
      ) do
    new_current_game =
      current_game
      |> Map.update(:votes, current_game.votes, fn votes ->
        Enum.concat(votes, [%{player_id: player_id, voted_who_played_cool: player_name}])
      end)

    new_state = Map.update(state, :current_game, state.current_game, fn _ -> new_current_game end)
    check_if_game_ended(new_state, players)
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
      IO.puts("VOTING BEGINS")

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

  defp check_if_game_ended(%{current_game: %{votes: votes} = _current_game} = state, players) do
    cond do
      length(votes) == length(players) ->
        %{
          players: players,
          games: games
        } = state

        scores = {1, 2, 3}

        reset_state = %{
          players: Enum.map(players, fn p -> %{id: p.id, name: p.name} end),
          games: games,
          scores: scores
        }

        {:noreply, reset_state}

      true ->
        IO.puts("Continue")
        {:noreply, state}
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
