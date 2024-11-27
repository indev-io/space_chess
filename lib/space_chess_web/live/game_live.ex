defmodule SpaceChessWeb.GameLive do
  alias SpaceChess.Game
  use SpaceChessWeb, :live_view
  alias SpaceChess.Game.DummyData
  alias SpaceChess.Accounts
  alias SpaceChess.GameEngine

  def mount(%{"game_id" => game_id}, %{"user_token" => user_token}, socket) do
    game_data = DummyData.dummy_server_check(game_id)
    chat_subscription = "game_chat:" <> game_id
    SpaceChessWeb.Endpoint.subscribe(chat_subscription)

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
      |> assign(:chat_subscription, chat_subscription)

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
        <div phx-hook="ThreeHook" id="threejs-container" phx-update="ignore"></div>
        <button phx-click="toggle_grid">Toggle Grid</button>
        <button phx-click="update_board">Update Board</button>
      </div>
      <div class="right">
        <chatarea class="game-chat">
          <%= for chat <- @chat_data do %>
            <div class="chat-message">
              <p><%= chat.sender %> - <%= chat.message %></p>
            </div>
          <% end %>
        </chatarea>
        <form phx-submit="send_message">
          <textarea class="game-chat-input" name="chat_message">
      </textarea>
          <button>Send</button>
        </form>
      </div>
    </main>
    """
  end

  def handle_event("toggle_grid", _params, socket) do
    {:noreply, push_event(socket, "toggle_grid", %{message: "toggle_grid"})}
  end

  def handle_event("update_board", _params, socket) do
    data = GameEngine.create_default_setup()
    {:noreply, push_event(socket, "update_board", data)}
  end

  def handle_event("send_message", %{"chat_message" => chat_message}, socket) do
    new_chat_data =
      socket.assigns.chat_data ++
        [
          %{
            game_id: socket.assigns.chat_subscription,
            message: chat_message,
            sender: "X"
          }
        ]

    SpaceChessWeb.Endpoint.broadcast(
      socket.assigns.chat_subscription,
      "send_message",
      new_chat_data
    )

    {:noreply, socket}
  end

  # def handle_event("unscramble_board", _params, socket) do
  #   {:noreply, push_event(socket, "unscramble_board", %{message: "board_unscrambler"})}
  # end

  def handle_info(info, socket) do
    socket = assign(socket, :chat_data, info.payload)
    {:noreply, socket}
  end
end
