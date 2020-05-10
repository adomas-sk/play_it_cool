defmodule PlayItCoolWeb.LobbyChannel do
  use Phoenix.Channel

  def join("lobby:" <> lobby_token, _params, socket) do
    case PlayItCool.GameLobby.get_game_state(lobby_token) do
      {:error, message} ->
        {:error, %{reason: message}}

      lobby_state ->
        {:ok, lobby_state, socket}
    end
  end
end
