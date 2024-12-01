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
    <main phx-window-keydown="keydown" class="game-main">
      <div class="left">
        <h1>Game Status: Awaiting Players</h1>
        <!--
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
            -->
        <div phx-hook="ThreeHook" id="threejs-container" phx-update="ignore"></div>
        <button phx-click="toggle_grid">Toggle Grid</button>
        <button phx-click="update_board">Update Board</button>
        <button phx-click="spin_left">⇠ spin left</button>
        <button phx-click="spin_right">spin right ⇢</button>
        <button phx-click="flip_forward">⇡ flip forward</button>
        <button phx-click="flip_backward">flip backward ⇣</button>
        <button phx-click="rotate_left">rotate left ⤣</button>
        <button phx-click="rotate_right">⤤ rotate right</button>
      </div>
      <!--
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
      -->
    </main>
    """
  end

  # buttons
  def handle_event("toggle_grid", _params, socket) do
    {:noreply, push_event(socket, "toggle_grid", %{message: "toggle_grid"})}
  end

  def handle_event("update_board", _params, socket) do
    data = GameEngine.create_default_setup()
    {:noreply, push_event(socket, "update_board", data)}
  end

  def handle_event("spin_right", _params, socket) do
    board_dimensions = IO.inspect(socket.assigns.game_data.board_dimensions)
    {:noreply, push_event(socket, "spin_right", board_dimensions)}
  end

  def handle_event("spin_left", _params, socket) do
    board_dimensions = IO.inspect(socket.assigns.game_data.board_dimensions)
    {:noreply, push_event(socket, "spin_left", board_dimensions)}
  end

  def handle_event("flip_forward", _params, socket) do
    board_dimensions = IO.inspect(socket.assigns.game_data.board_dimensions)
    {:noreply, push_event(socket, "flip_forward", board_dimensions)}
  end

  def handle_event("flip_backward", _params, socket) do
    board_dimensions = IO.inspect(socket.assigns.game_data.board_dimensions)
    {:noreply, push_event(socket, "flip_backward", board_dimensions)}
  end

  def handle_event("rotate_left", _params, socket) do
    board_dimensions = IO.inspect(socket.assigns.game_data.board_dimensions)
    {:noreply, push_event(socket, "rotate_left", board_dimensions)}
  end

  def handle_event("rotate_right", _params, socket) do
    board_dimensions = IO.inspect(socket.assigns.game_data.board_dimensions)
    {:noreply, push_event(socket, "rotate_right", board_dimensions)}
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

  # keys
  def handle_event("keydown", %{"key" => key}, socket) do
    {:noreply, push_event(socket, "keydown", %{key: key})}
  end

  def handle_info(info, socket) do
    socket = assign(socket, :chat_data, info.payload)
    {:noreply, socket}
  end
end
