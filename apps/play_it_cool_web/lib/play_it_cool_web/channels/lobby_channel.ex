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
        IO.inspect(lobby_state, label: "LOBBY STATE")

        case Enum.find(lobby_state.players, fn p -> p.name == player_name end) do
          nil ->
            {:error, %{reason: "Invalid token"}}

          _ ->
            send(self(), {:after_join, lobby_token, player_name, token})
            {:ok, %{players: lobby_state.players, lobbyMaster: lobby_state.lobby_master}, socket}
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

  def handle_info({:after_join, lobby_token, player_name, player_token}, socket) do
    PlayItCool.GameLobby.save_player_token(lobby_token, player_name, player_token)

    {:noreply, socket}
  end
end
