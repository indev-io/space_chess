defmodule SpaceChessWeb.GameLive do
  use SpaceChessWeb, :live_view
  alias SpaceChess.Game.DummyData
  alias SpaceChess.Accounts

  def mount(%{"game_id" => game_id}, %{"user_token" => user_token} = _session, socket) do
    game_data = DummyData.dummy_server_check(game_id)

    socket =
      socket
      |> assign_new(:current_user, fn ->
        Accounts.get_user_by_session_token(user_token)
      end)
      |> push_event("setup_game", game_data)
      |> assign_new(:chat_data, fn ->
        DummyData.dummy_server_chat(game_id)
      end)
      |> assign(:game_data, game_data)

    IO.inspect(socket)

    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <main class="game-main">
      <div class="left">
        <h1>Game Status: Awaiting Players</h1>
        <div id="players">
          <%= for player <- @game_data.players do %>
            <div class="player">
              <div class="player-info">
                <h1><%= player.name %></h1>
              </div>
              <div class="game-options">
                <%= if @current_user.id === player.id  do %>
                  <button class="game-buttons join">join game</button>
                  <button class="game-buttons decline">decline</button>
                <% else %>
                  <button class="game-buttons game-buttons-waiting">
                    Waiting for player to join
                  </button>
                <% end %>
              </div>
            </div>
          <% end %>
        </div>
        <div phx-update phx-hook="ThreeHook" id="threejs-container" phx-update="ignore"></div>
        <button phx-click="toggle_grid">Toggle Grid</button>
      </div>
      <div class="right">
        <chatarea class="game-chat">
          <%= for chat <- @chat_data do %>
            <div>
              <h1><%= chat.message %></h1>
              <p><%= chat.sender %></p>
            </div>
          <% end %>
        </chatarea>
        <textarea class="game-chat-input">
      </textarea>
        <button>Send</button>
      </div>
    </main>
    """
  end

  def handle_event("toggle_grid", _params, socket) do
    {:noreply, push_event(socket, "toggle_grid", %{message: "toggle_grid"})}
  end

  # def handle_event("unscramble_board", _params, socket) do
  #   {:noreply, push_event(socket, "unscramble_board", %{message: "board_unscrambler"})}
  # end
end
