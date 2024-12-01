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

  @possible_colors %{
    player1color: 0xD4AF37,
    player2color: 0xC7D1DA,
    player3color: 0xB87333,
    player4color: 0x00D062,
    player5color: 0xE0115F,
    player6color: 0x0F52BA,
    player7color: 0xFFFFFF,
    player8color: 0x000000,
    highlightColor: 0x00FF00,
    cursorColor: 0x0000FF,
    captureColor: 0xFF0000
  }

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
      board_dimensions: %{rows: 5, columns: 5, levels: 8},
      pieces: %{
        rook1: %{
          name: "rook1",
          coords: [1, 1, 1],
          owner: "player1",
          color: 0xD4AF37,
          model: "BoxGeometry( 0.5, 0.5, 0.5 )"
        },
        knight1: %{
          name: "knight1",
          coords: [2, 1, 1],
          owner: "player1",
          color: 0xD4AF37,
          model: "IcosahedronGeometry( 0.45 )"
        },
        king1: %{
          name: "king1",
          coords: [3, 1, 1],
          owner: "player1",
          color: 0xD4AF37,
          model: "TorusGeometry(0.3, 0.15, 15, 15 )"
        },
        knight2: %{
          name: "knight2",
          coords: [4, 1, 1],
          owner: "player1",
          color: 0xD4AF37,
          model: "IcosahedronGeometry( 0.45 )"
        },
        rook2: %{
          name: "rook2",
          coords: [5, 1, 1],
          owner: "player1",
          color: 0xD4AF37,
          model: "BoxGeometry( 0.5, 0.5, 0.5 )"
        },
        pawn1: %{
          name: "pawn1",
          coords: [1, 2, 1],
          owner: "player1",
          color: 0xD4AF37,
          model: "TetrahedronGeometry( 0.5 )"
        },
        pawn2: %{
          name: "pawn2",
          coords: [2, 2, 1],
          owner: "player1",
          color: 0xD4AF37,
          model: "TetrahedronGeometry( 0.5 )"
        },
        pawn3: %{
          name: "pawn3",
          coords: [3, 2, 1],
          owner: "player1",
          color: 0xD4AF37,
          model: "TetrahedronGeometry( 0.5 )"
        },
        pawn4: %{
          name: "pawn4",
          coords: [4, 2, 1],
          owner: "player1",
          color: 0xD4AF37,
          model: "TetrahedronGeometry( 0.5 )"
        },
        pawn5: %{
          name: "pawn5",
          coords: [5, 2, 1],
          owner: "player1",
          color: 0xD4AF37,
          model: "TetrahedronGeometry( 0.5 )"
        },
        bishop1: %{
          name: "bishop1",
          coords: [1, 1, 2],
          owner: "player1",
          color: 0xD4AF37,
          model: "OctahedronGeometry( 0.5 )"
        },
        unicorn1: %{
          name: "unicorn1",
          coords: [2, 1, 2],
          owner: "player1",
          color: 0xD4AF37,
          model: "ConeGeometry(0.3, 0.8, 15 )"
        },
        queen1: %{
          name: "queen1",
          coords: [3, 1, 2],
          owner: "player1",
          color: 0xD4AF37,
          model: "SphereGeometry( 0.4, 15, 15)"
        },
        bishop2: %{
          name: "bishop2",
          coords: [4, 1, 2],
          owner: "player1",
          color: 0xD4AF37,
          model: "OctahedronGeometry( 0.5 )"
        },
        unicorn2: %{
          name: "unicorn2",
          coords: [5, 1, 2],
          owner: "player1",
          color: 0xD4AF37,
          model: "ConeGeometry(0.3, 0.8, 15 )"
        },
        pawn6: %{
          name: "pawn6",
          coords: [1, 2, 2],
          owner: "player1",
          color: 0xD4AF37,
          model: "TetrahedronGeometry( 0.5 )"
        },
        pawn7: %{
          name: "pawn7",
          coords: [2, 2, 2],
          owner: "player1",
          color: 0xD4AF37,
          model: "TetrahedronGeometry( 0.5 )"
        },
        pawn8: %{
          name: "pawn8",
          coords: [3, 2, 2],
          owner: "player1",
          color: 0xD4AF37,
          model: "TetrahedronGeometry( 0.5 )"
        },
        pawn9: %{
          name: "pawn9",
          coords: [4, 2, 2],
          owner: "player1",
          color: 0xD4AF37,
          model: "TetrahedronGeometry( 0.5 )"
        },
        pawn10: %{
          name: "pawn10",
          coords: [5, 2, 2],
          owner: "player1",
          color: 0xD4AF37,
          model: "TetrahedronGeometry( 0.5 )"
        },
        rook3: %{
          name: "rook3",
          coords: [1, 5, 5],
          owner: "player2",
          color: 0xC7D1DA,
          model: "BoxGeometry( 0.5, 0.5, 0.5 )"
        },
        knight3: %{
          name: "knight3",
          coords: [2, 5, 5],
          owner: "player2",
          color: 0xC7D1DA,
          model: "IcosahedronGeometry( 0.45 )"
        },
        king2: %{
          name: "king2",
          coords: [3, 5, 5],
          owner: "player2",
          color: 0xC7D1DA,
          model: "TorusGeometry(0.3, 0.15, 15, 15 )"
        },
        knight4: %{
          name: "knight4",
          coords: [4, 5, 5],
          owner: "player2",
          color: 0xC7D1DA,
          model: "IcosahedronGeometry( 0.45 )"
        },
        rook4: %{
          name: "rook4",
          coords: [5, 5, 5],
          owner: "player2",
          color: 0xC7D1DA,
          model: "BoxGeometry( 0.5, 0.5, 0.5 )"
        },
        pawn11: %{
          name: "pawn11",
          coords: [1, 4, 5],
          owner: "player2",
          color: 0xC7D1DA,
          model: "TetrahedronGeometry( 0.5 )"
        },
        pawn12: %{
          name: "pawn12",
          coords: [2, 4, 5],
          owner: "player2",
          color: 0xC7D1DA,
          model: "TetrahedronGeometry( 0.5 )"
        },
        pawn13: %{
          name: "pawn13",
          coords: [3, 4, 5],
          owner: "player2",
          color: 0xC7D1DA,
          model: "TetrahedronGeometry( 0.5 )"
        },
        pawn14: %{
          name: "pawn14",
          coords: [4, 4, 5],
          owner: "player2",
          color: 0xC7D1DA,
          model: "TetrahedronGeometry( 0.5 )"
        },
        pawn15: %{
          name: "pawn15",
          coords: [5, 4, 5],
          owner: "player2",
          color: 0xC7D1DA,
          model: "TetrahedronGeometry( 0.5 )"
        },
        unicorn3: %{
          name: "unicorn3",
          coords: [1, 5, 4],
          owner: "player2",
          color: 0xC7D1DA,
          model: "ConeGeometry(0.3, 0.8, 15 )"
        },
        bishop3: %{
          name: "bishop3",
          coords: [2, 5, 4],
          owner: "player2",
          color: 0xC7D1DA,
          model: "OctahedronGeometry( 0.5 )"
        },
        queen2: %{
          name: "queen2",
          coords: [3, 5, 4],
          owner: "player2",
          color: 0xC7D1DA,
          model: "TorusGeometry(0.3, 0.15, 15, 15 )"
        },
        unicorn4: %{
          name: "unicorn4",
          coords: [4, 5, 4],
          owner: "player2",
          color: 0xC7D1DA,
          model: "ConeGeometry(0.3, 0.8, 15 )"
        },
        bishop4: %{
          name: "bishop4",
          coords: [5, 5, 4],
          owner: "player2",
          color: 0xC7D1DA,
          model: "OctahedronGeometry( 0.5 )"
        },
        pawn16: %{
          name: "pawn16",
          coords: [1, 4, 4],
          owner: "player2",
          color: 0xC7D1DA,
          model: "TetrahedronGeometry( 0.5 )"
        },
        pawn17: %{
          name: "pawn17",
          coords: [2, 4, 4],
          owner: "player2",
          color: 0xC7D1DA,
          model: "TetrahedronGeometry( 0.5 )"
        },
        pawn18: %{
          name: "pawn18",
          coords: [3, 4, 4],
          owner: "player2",
          color: 0xC7D1DA,
          model: "TetrahedronGeometry( 0.5 )"
        },
        pawn19: %{
          name: "pawn19",
          coords: [4, 4, 4],
          owner: "player2",
          color: 0xC7D1DA,
          model: "TetrahedronGeometry( 0.5 )"
        },
        pawn20: %{
          name: "pawn20",
          coords: [5, 4, 4],
          owner: "player2",
          color: 0xC7D1DA,
          model: "TetrahedronGeometry( 0.5 )"
        }
      }
    },
    %{
      game_id: "def456",
      players: [
        %{id: 2, name: "Zimzam"},
        %{id: 4, name: "bizarro_devin"}
      ],
      board_dimensions: %{rows: 5, columns: 5, levels: 5},
      pieces: %{
        rook1: %{
          name: "rook1",
          coords: [1, 1, 1],
          owner: "player1",
          color: 0xD4AF37,
          model: "BoxGeometry( 0.5, 0.5, 0.5 )"
        },
        knight1: %{
          name: "knight1",
          coords: [2, 1, 1],
          owner: "player1",
          color: 0xD4AF37,
          model: "IcosahedronGeometry( 0.45 )"
        },
        king1: %{
          name: "king1",
          coords: [3, 1, 1],
          owner: "player1",
          color: 0xD4AF37,
          model: "TorusGeometry(0.3, 0.15, 15, 15 )"
        },
        knight2: %{
          name: "knight2",
          coords: [4, 1, 1],
          owner: "player1",
          color: 0xD4AF37,
          model: "IcosahedronGeometry( 0.45 )"
        },
        rook2: %{
          name: "rook2",
          coords: [5, 1, 1],
          owner: "player1",
          color: 0xD4AF37,
          model: "BoxGeometry( 0.5, 0.5, 0.5 )"
        },
        pawn1: %{
          name: "pawn1",
          coords: [1, 2, 1],
          owner: "player1",
          color: 0xD4AF37,
          model: "TetrahedronGeometry( 0.5 )"
        },
        pawn2: %{
          name: "pawn2",
          coords: [2, 2, 1],
          owner: "player1",
          color: 0xD4AF37,
          model: "TetrahedronGeometry( 0.5 )"
        },
        pawn3: %{
          name: "pawn3",
          coords: [3, 2, 1],
          owner: "player1",
          color: 0xD4AF37,
          model: "TetrahedronGeometry( 0.5 )"
        },
        pawn4: %{
          name: "pawn4",
          coords: [4, 2, 1],
          owner: "player1",
          color: 0xD4AF37,
          model: "TetrahedronGeometry( 0.5 )"
        },
        pawn5: %{
          name: "pawn5",
          coords: [5, 2, 1],
          owner: "player1",
          color: 0xD4AF37,
          model: "TetrahedronGeometry( 0.5 )"
        },
        bishop1: %{
          name: "bishop1",
          coords: [1, 1, 2],
          owner: "player1",
          color: 0xD4AF37,
          model: "OctahedronGeometry( 0.5 )"
        },
        unicorn1: %{
          name: "unicorn1",
          coords: [2, 1, 2],
          owner: "player1",
          color: 0xD4AF37,
          model: "ConeGeometry(0.3, 0.8, 15 )"
        },
        queen1: %{
          name: "queen1",
          coords: [3, 1, 2],
          owner: "player1",
          color: 0xD4AF37,
          model: "SphereGeometry( 0.4, 15, 15)"
        },
        bishop2: %{
          name: "bishop2",
          coords: [4, 1, 2],
          owner: "player1",
          color: 0xD4AF37,
          model: "OctahedronGeometry( 0.5 )"
        },
        unicorn2: %{
          name: "unicorn2",
          coords: [5, 1, 2],
          owner: "player1",
          color: 0xD4AF37,
          model: "ConeGeometry(0.3, 0.8, 15 )"
        },
        pawn6: %{
          name: "pawn6",
          coords: [1, 2, 2],
          owner: "player1",
          color: 0xD4AF37,
          model: "TetrahedronGeometry( 0.5 )"
        },
        pawn7: %{
          name: "pawn7",
          coords: [2, 2, 2],
          owner: "player1",
          color: 0xD4AF37,
          model: "TetrahedronGeometry( 0.5 )"
        },
        pawn8: %{
          name: "pawn8",
          coords: [3, 2, 2],
          owner: "player1",
          color: 0xD4AF37,
          model: "TetrahedronGeometry( 0.5 )"
        },
        pawn9: %{
          name: "pawn9",
          coords: [4, 2, 2],
          owner: "player1",
          color: 0xD4AF37,
          model: "TetrahedronGeometry( 0.5 )"
        },
        pawn10: %{
          name: "pawn10",
          coords: [5, 2, 2],
          owner: "player1",
          color: 0xD4AF37,
          model: "TetrahedronGeometry( 0.5 )"
        },
        rook3: %{
          name: "rook3",
          coords: [1, 5, 5],
          owner: "player2",
          color: 0xC7D1DA,
          model: "BoxGeometry( 0.5, 0.5, 0.5 )"
        },
        knight3: %{
          name: "knight3",
          coords: [2, 5, 5],
          owner: "player2",
          color: 0xC7D1DA,
          model: "IcosahedronGeometry( 0.45 )"
        },
        king2: %{
          name: "king2",
          coords: [3, 5, 5],
          owner: "player2",
          color: 0xC7D1DA,
          model: "TorusGeometry(0.3, 0.15, 15, 15 )"
        },
        knight4: %{
          name: "knight4",
          coords: [4, 5, 5],
          owner: "player2",
          color: 0xC7D1DA,
          model: "IcosahedronGeometry( 0.45 )"
        },
        rook4: %{
          name: "rook4",
          coords: [5, 5, 5],
          owner: "player2",
          color: 0xC7D1DA,
          model: "BoxGeometry( 0.5, 0.5, 0.5 )"
        },
        pawn11: %{
          name: "pawn11",
          coords: [1, 4, 5],
          owner: "player2",
          color: 0xC7D1DA,
          model: "TetrahedronGeometry( 0.5 )"
        },
        pawn12: %{
          name: "pawn12",
          coords: [2, 4, 5],
          owner: "player2",
          color: 0xC7D1DA,
          model: "TetrahedronGeometry( 0.5 )"
        },
        pawn13: %{
          name: "pawn13",
          coords: [3, 4, 5],
          owner: "player2",
          color: 0xC7D1DA,
          model: "TetrahedronGeometry( 0.5 )"
        },
        pawn14: %{
          name: "pawn14",
          coords: [4, 4, 5],
          owner: "player2",
          color: 0xC7D1DA,
          model: "TetrahedronGeometry( 0.5 )"
        },
        pawn15: %{
          name: "pawn15",
          coords: [5, 4, 5],
          owner: "player2",
          color: 0xC7D1DA,
          model: "TetrahedronGeometry( 0.5 )"
        },
        unicorn3: %{
          name: "unicorn3",
          coords: [1, 5, 4],
          owner: "player2",
          color: 0xC7D1DA,
          model: "ConeGeometry(0.3, 0.8, 15 )"
        },
        bishop3: %{
          name: "bishop3",
          coords: [2, 5, 4],
          owner: "player2",
          color: 0xC7D1DA,
          model: "OctahedronGeometry( 0.5 )"
        },
        queen2: %{
          name: "queen2",
          coords: [3, 5, 4],
          owner: "player2",
          color: 0xC7D1DA,
          model: "TorusGeometry(0.3, 0.15, 15, 15 )"
        },
        unicorn4: %{
          name: "unicorn4",
          coords: [4, 5, 4],
          owner: "player2",
          color: 0xC7D1DA,
          model: "ConeGeometry(0.3, 0.8, 15 )"
        },
        bishop4: %{
          name: "bishop4",
          coords: [5, 5, 4],
          owner: "player2",
          color: 0xC7D1DA,
          model: "OctahedronGeometry( 0.5 )"
        },
        pawn16: %{
          name: "pawn16",
          coords: [1, 4, 4],
          owner: "player2",
          color: 0xC7D1DA,
          model: "TetrahedronGeometry( 0.5 )"
        },
        pawn17: %{
          name: "pawn17",
          coords: [2, 4, 4],
          owner: "player2",
          color: 0xC7D1DA,
          model: "TetrahedronGeometry( 0.5 )"
        },
        pawn18: %{
          name: "pawn18",
          coords: [3, 4, 4],
          owner: "player2",
          color: 0xC7D1DA,
          model: "TetrahedronGeometry( 0.5 )"
        },
        pawn19: %{
          name: "pawn19",
          coords: [4, 4, 4],
          owner: "player2",
          color: 0xC7D1DA,
          model: "TetrahedronGeometry( 0.5 )"
        },
        pawn20: %{
          name: "pawn20",
          coords: [5, 4, 4],
          owner: "player2",
          color: 0xC7D1DA,
          model: "TetrahedronGeometry( 0.5 )"
        }
      }
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
