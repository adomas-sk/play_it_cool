defmodule PlayItCool.GameLobby do
  use GenServer

  @spec start_link(String.t()) :: :ignore | {:error, any} | {:ok, pid}
  def start_link(lobby_token) do
    name = {:via, Registry, {Registry.GameLobbies, lobby_token}}
    GenServer.start_link(__MODULE__, %{}, name: name)
  end

  @impl true
  @spec init(any) :: {:ok, %{games: [], players: []}}
  def init(_) do
    IO.puts("GenServer STARTED")

    {:ok,
     %{
       players: [],
       games: []
     }}
  end

  @impl true
  def handle_cast({:add_player, player}, state) do
    {:noreply,
     Map.update(state, :players, state.players, fn existing_players ->
       [player | existing_players]
     end)}
  end

  @impl true
  def handle_cast({:start_game, game_data}, state) do
    cond do
      state.current_game ->
        {:error, "Game is already in progress"}

      true ->
        new_state =
          state
          |> Map.update(:games, state.games, fn past_games -> [game_data | past_games] end)
          |> Map.put_new(:current_game, game_data)

        {:noreply, new_state}
    end
  end

  @impl true
  def handle_call(:get_state, _from, state) do
    {:reply, state, state}
  end

  @spec find_game_lobby(String.t()) :: pid
  def find_game_lobby(lobby_token) do
    [{pid, nil}] = Registry.lookup(Registry.GameLobbies, lobby_token)
    pid
  end

  @spec add_player(%{id: identifier(), name: String.t()}, String.t()) :: any()
  def add_player(player, lobby_token) do
    find_game_lobby(lobby_token)
    |> GenServer.cast({:add_player, player})
  end

  def get_game_state(lobby_token) do
    find_game_lobby(lobby_token)
    |> GenServer.call(:get_state)
  end

  def start_new_game(game_data, lobby_token) do
    find_game_lobby(lobby_token)
    |> GenServer.cast({:start_game, game_data})
  end
end
