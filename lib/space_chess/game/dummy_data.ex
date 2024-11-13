defmodule SpaceChess.Game.DummyData do
  def generate_dummy_board do
    board = create_board(5, 5, 5)
    board = add_pieces_to_board(board, 5)
    IO.inspect(board)
  end

  def create_board(rows, columns, levels) do
    Map.new(
      for row <- 1..rows,
          column <- 1..columns,
          level <- 1..levels,
          do: {{row, column, level}, :empty}
    )
  end

  def add_pieces_to_board(board, count) when count > 0 do
    row = Enum.random(1..5)
    column = Enum.random(1..5)
    level = Enum.random(1..5)
    board = Map.put(board, {row, column, level}, :pawn)
    add_pieces_to_board(board, count - 1)
  end

  def add_pieces_to_board(board, _count) do
    board
  end

  @ideal_game_data %{
    game_uuid: 120_123_879,
    players: [
      %{
        id: 123,
        name: "what"
      },
      %{
        id: 124,
        name: "who"
      },
      %{
        id: 125,
        name: "where"
      }
    ]
  }

  @dummy_game_data [
    %{
      game_id: "abc123",
      players: [
        %{id: 2, name: "devin"},
        %{id: 4, name: "bizarro_devin"}
      ],
      board_dimensions: %{rows: 5, columns: 8, levels: 3}
    },
    %{
      game_id: "def456",
      players: [
        %{id: 1, name: "devin"},
        %{id: 2, name: "Zimzam"},
        %{id: 4, name: "bizarro_devin"}
      ],
      board_dimensions: %{rows: 2, columns: 2, levels: 2}
    }
  ]

  @dummy_chat_data [
    %{
      game_id: "def456",
      message: "Yo",
      sender: "ZimZam"
    },
    %{
      game_id: "def456",
      message: "Sup",
      sender: "Bizarro Devin"
    },
    %{
      game_id: "abc123",
      message: "Good Stuff",
      sender: "devin"
    }
  ]

  def dummy_server_check(game_id) do
    Enum.find(@dummy_game_data, fn x -> x.game_id === game_id end)
  end

  def dummy_server_chat(game_id) do
    Enum.filter(@dummy_chat_data, fn x -> x.game_id === game_id end)
  end

  def add_chat(chat, socket) do
    socket.assigns.chat_data ++
      [
        %{
          game_id: "abc123",
          message: chat,
          sender: "Devin"
        }
      ]
  end
end
