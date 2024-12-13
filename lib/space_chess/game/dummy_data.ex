defmodule SpaceChess.Game.DummyData do
  alias SpaceChess.GameEngine
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

  # promotion zones are zones where you the PLAYER can promote their pieces.
  # promotion zones are often on the opposite side of the map
  @dummy_process_data [
    %{
      game_id: "abc123",
      players: %{
        1 => %{id: 2, name: "devin"},
        2 => %{id: 4, name: "bizarro_devin"}
      },
      default_camera_orientation: %{
        player1: %{up: [0, 0, 1], facing: [0, 1, 0]},
        player2: %{up: [0, 0, -1], facing: [0, -1, 0]}
      },
      board_dimensions: %{rows: 5, columns: 5, levels: 5},
      turn: 1,
      round: 1,
      promotion_zones: %{
        1 => [{1, 5, 5}, {2, 5, 5}, {3, 5, 5}, {4, 5, 5}, {5, 5, 5}],
        2 => [{1, 1, 1}, {2, 1, 1}, {3, 1, 1}, {4, 1, 1}, {5, 1, 1}]
      },
      piece_behavior: %{
        pawn: %{
          abbreviation: "p",
          opts: [regular_promotion: true],
          movement: [
            %{transformation: {0, 1, 0}, steps: 1, opts: [movement_only: true], branches: []},
            %{transformation: {0, 0, 1}, steps: 1, opts: [movement_only: true], branches: []},
            %{transformation: {-1, 1, 0}, steps: 1, opts: [capture_only: true], branches: []},
            %{transformation: {1, 1, 0}, steps: 1, opts: [capture_only: true], branches: []},
            %{transformation: {-1, 0, 1}, steps: 1, opts: [capture_only: true], branches: []},
            %{transformation: {1, 0, 1}, steps: 1, opts: [capture_only: true], branches: []}
          ]
        },
        rook: %{
          abbreviation: "r",
          opts: [],
          movement: [
            %{transformation: {0, 0, -1}, steps: :infinity, opts: [], branches: []},
            %{transformation: {0, 1, 0}, steps: :infinity, opts: [], branches: []},
            %{transformation: {-1, 0, 0}, steps: :infinity, opts: [], branches: []},
            %{transformation: {1, 0, 0}, steps: :infinity, opts: [], branches: []},
            %{transformation: {0, -1, 0}, steps: :infinity, opts: [], branches: []},
            %{transformation: {0, 0, 1}, steps: :infinity, opts: [], branches: []}
          ]
        },
        knight: %{
          abbreviation: "n",
          opts: [],
          movement: [
            %{
              transformation: {0, 0, -1},
              steps: 1,
              opts: [dont_record: true, jump: true],
              branches: [
                %{
                  transformation: {0, 1, 0},
                  steps: 2,
                  opts: [jump: true, endpoint_only: true],
                  branches: []
                },
                %{
                  transformation: {-1, 0, 0},
                  steps: 2,
                  opts: [jump: true, endpoint_only: true],
                  branches: []
                },
                %{
                  transformation: {1, 0, 0},
                  steps: 2,
                  opts: [jump: true, endpoint_only: true],
                  branches: []
                },
                %{
                  transformation: {0, -1, 0},
                  steps: 2,
                  opts: [jump: true, endpoint_only: true],
                  branches: []
                }
              ]
            },
            %{
              transformation: {0, 1, 0},
              steps: 1,
              opts: [dont_record: true, jump: true],
              branches: [
                %{
                  transformation: {0, 0, -1},
                  steps: 2,
                  opts: [jump: true, endpoint_only: true],
                  branches: []
                },
                %{
                  transformation: {-1, 0, 0},
                  steps: 2,
                  opts: [jump: true, endpoint_only: true],
                  branches: []
                },
                %{
                  transformation: {1, 0, 0},
                  steps: 2,
                  opts: [jump: true, endpoint_only: true],
                  branches: []
                },
                %{
                  transformation: {0, 0, 1},
                  steps: 2,
                  opts: [jump: true, endpoint_only: true],
                  branches: []
                }
              ]
            },
            %{
              transformation: {-1, 0, 0},
              steps: 1,
              opts: [dont_record: true, jump: true],
              branches: [
                %{
                  transformation: {0, 0, -1},
                  steps: 2,
                  opts: [jump: true, endpoint_only: true],
                  branches: []
                },
                %{
                  transformation: {0, 1, 0},
                  steps: 2,
                  opts: [jump: true, endpoint_only: true],
                  branches: []
                },
                %{
                  transformation: {0, -1, 0},
                  steps: 2,
                  opts: [jump: true, endpoint_only: true],
                  branches: []
                },
                %{
                  transformation: {0, 0, 1},
                  steps: 2,
                  opts: [jump: true, endpoint_only: true],
                  branches: []
                }
              ]
            },
            %{
              transformation: {1, 0, 0},
              steps: 1,
              opts: [dont_record: true, jump: true],
              branches: [
                %{
                  transformation: {0, 0, -1},
                  steps: 2,
                  opts: [jump: true, endpoint_only: true],
                  branches: []
                },
                %{
                  transformation: {0, 1, 0},
                  steps: 2,
                  opts: [jump: true, endpoint_only: true],
                  branches: []
                },
                %{
                  transformation: {0, -1, 0},
                  steps: 2,
                  opts: [jump: true, endpoint_only: true],
                  branches: []
                },
                %{
                  transformation: {0, 0, 1},
                  steps: 2,
                  opts: [jump: true, endpoint_only: true],
                  branches: []
                }
              ]
            },
            %{
              transformation: {0, -1, 0},
              steps: 1,
              opts: [dont_record: true, jump: true],
              branches: [
                %{
                  transformation: {0, 0, -1},
                  steps: 2,
                  opts: [jump: true, endpoint_only: true],
                  branches: []
                },
                %{
                  transformation: {-1, 0, 0},
                  steps: 2,
                  opts: [jump: true, endpoint_only: true],
                  branches: []
                },
                %{
                  transformation: {1, 0, 0},
                  steps: 2,
                  opts: [jump: true, endpoint_only: true],
                  branches: []
                },
                %{
                  transformation: {0, 0, 1},
                  steps: 2,
                  opts: [jump: true, endpoint_only: true],
                  branches: []
                }
              ]
            },
            %{
              transformation: {0, 0, 1},
              steps: 1,
              opts: [dont_record: true, jump: true],
              branches: [
                %{
                  transformation: {0, 1, 0},
                  steps: 2,
                  opts: [jump: true, endpoint_only: true],
                  branches: []
                },
                %{
                  transformation: {-1, 0, 0},
                  steps: 2,
                  opts: [jump: true, endpoint_only: true],
                  branches: []
                },
                %{
                  transformation: {1, 0, 0},
                  steps: 2,
                  opts: [jump: true, endpoint_only: true],
                  branches: []
                },
                %{
                  transformation: {0, -1, 0},
                  steps: 2,
                  opts: [jump: true, endpoint_only: true],
                  branches: []
                }
              ]
            },
            %{
              transformation: {0, 0, -1},
              steps: 2,
              opts: [dont_record: true, jump: true],
              branches: [
                %{
                  transformation: {0, 1, 0},
                  steps: 1,
                  opts: [jump: true, endpoint_only: true],
                  branches: []
                },
                %{
                  transformation: {-1, 0, 0},
                  steps: 1,
                  opts: [jump: true, endpoint_only: true],
                  branches: []
                },
                %{
                  transformation: {1, 0, 0},
                  steps: 1,
                  opts: [jump: true, endpoint_only: true],
                  branches: []
                },
                %{
                  transformation: {0, -1, 0},
                  steps: 1,
                  opts: [jump: true, endpoint_only: true],
                  branches: []
                }
              ]
            },
            %{
              transformation: {0, 1, 0},
              steps: 2,
              opts: [dont_record: true, jump: true],
              branches: [
                %{
                  transformation: {0, 0, -1},
                  steps: 1,
                  opts: [jump: true, endpoint_only: true],
                  branches: []
                },
                %{
                  transformation: {-1, 0, 0},
                  steps: 1,
                  opts: [jump: true, endpoint_only: true],
                  branches: []
                },
                %{
                  transformation: {1, 0, 0},
                  steps: 1,
                  opts: [jump: true, endpoint_only: true],
                  branches: []
                },
                %{
                  transformation: {0, 0, 1},
                  steps: 1,
                  opts: [jump: true, endpoint_only: true],
                  branches: []
                }
              ]
            },
            %{
              transformation: {-1, 0, 0},
              steps: 2,
              opts: [dont_record: true, jump: true],
              branches: [
                %{
                  transformation: {0, 0, -1},
                  steps: 1,
                  opts: [jump: true, endpoint_only: true],
                  branches: []
                },
                %{
                  transformation: {0, 1, 0},
                  steps: 1,
                  opts: [jump: true, endpoint_only: true],
                  branches: []
                },
                %{
                  transformation: {0, -1, 0},
                  steps: 1,
                  opts: [jump: true, endpoint_only: true],
                  branches: []
                },
                %{
                  transformation: {0, 0, 1},
                  steps: 1,
                  opts: [jump: true, endpoint_only: true],
                  branches: []
                }
              ]
            },
            %{
              transformation: {1, 0, 0},
              steps: 2,
              opts: [dont_record: true, jump: true],
              branches: [
                %{
                  transformation: {0, 0, -1},
                  steps: 1,
                  opts: [jump: true, endpoint_only: true],
                  branches: []
                },
                %{
                  transformation: {0, 1, 0},
                  steps: 1,
                  opts: [jump: true, endpoint_only: true],
                  branches: []
                },
                %{
                  transformation: {0, -1, 0},
                  steps: 1,
                  opts: [jump: true, endpoint_only: true],
                  branches: []
                },
                %{
                  transformation: {0, 0, 1},
                  steps: 1,
                  opts: [jump: true, endpoint_only: true],
                  branches: []
                }
              ]
            },
            %{
              transformation: {0, -1, 0},
              steps: 2,
              opts: [dont_record: true, jump: true],
              branches: [
                %{
                  transformation: {0, 0, -1},
                  steps: 1,
                  opts: [jump: true, endpoint_only: true],
                  branches: []
                },
                %{
                  transformation: {-1, 0, 0},
                  steps: 1,
                  opts: [jump: true, endpoint_only: true],
                  branches: []
                },
                %{
                  transformation: {1, 0, 0},
                  steps: 1,
                  opts: [jump: true, endpoint_only: true],
                  branches: []
                },
                %{
                  transformation: {0, 0, 1},
                  steps: 1,
                  opts: [jump: true, endpoint_only: true],
                  branches: []
                }
              ]
            },
            %{
              transformation: {0, 0, 1},
              steps: 2,
              opts: [dont_record: true, jump: true],
              branches: [
                %{
                  transformation: {0, 1, 0},
                  steps: 1,
                  opts: [jump: true, endpoint_only: true],
                  branches: []
                },
                %{
                  transformation: {-1, 0, 0},
                  steps: 1,
                  opts: [jump: true, endpoint_only: true],
                  branches: []
                },
                %{
                  transformation: {1, 0, 0},
                  steps: 1,
                  opts: [jump: true, endpoint_only: true],
                  branches: []
                },
                %{
                  transformation: {0, -1, 0},
                  steps: 1,
                  opts: [jump: true, endpoint_only: true],
                  branches: []
                }
              ]
            }
          ]
        },
        bishop: %{
          abbreviation: "b",
          opts: [],
          movement: [
            %{transformation: {0, 1, -1}, steps: :infinity, opts: [], branches: []},
            %{transformation: {-1, 1, -1}, steps: :infinity, opts: [], branches: []},
            %{transformation: {1, 0, -1}, steps: :infinity, opts: [], branches: []},
            %{transformation: {0, -1, -1}, steps: :infinity, opts: [], branches: []},
            %{transformation: {-1, -1, 0}, steps: :infinity, opts: [], branches: []},
            %{transformation: {1, 1, 0}, steps: :infinity, opts: [], branches: []},
            %{transformation: {-1, -1, 0}, steps: :infinity, opts: [], branches: []},
            %{transformation: {1, -1, 0}, steps: :infinity, opts: [], branches: []},
            %{transformation: {0, 1, 1}, steps: :infinity, opts: [], branches: []},
            %{transformation: {-1, 0, 1}, steps: :infinity, opts: [], branches: []},
            %{transformation: {1, 0, 1}, steps: :infinity, opts: [], branches: []},
            %{transformation: {0, -1, 1}, steps: :infinity, opts: [], branches: []}
          ]
        },
        unicorn: %{
          abbreviation: "u",
          opts: [],
          movement: [
            %{transformation: {-1, 1, -1}, steps: :infinity, opts: [], branches: []},
            %{transformation: {1, 1, -1}, steps: :infinity, opts: [], branches: []},
            %{transformation: {-1, -1, -1}, steps: :infinity, opts: [], branches: []},
            %{transformation: {1, -1, -1}, steps: :infinity, opts: [], branches: []},
            %{transformation: {-1, 1, 1}, steps: :infinity, opts: [], branches: []},
            %{transformation: {1, 1, 1}, steps: :infinity, opts: [], branches: []},
            %{transformation: {-1, -1, 1}, steps: :infinity, opts: [], branches: []},
            %{transformation: {1, -1, 1}, steps: :infinity, opts: [], branches: []}
          ]
        },
        queen: %{
          abbreviation: "u",
          opts: [],
          movement: [
            %{transformation: {0, 0, -1}, steps: :infinity, opts: [], branches: []},
            %{transformation: {0, 1, 0}, steps: :infinity, opts: [], branches: []},
            %{transformation: {-1, 0, 0}, steps: :infinity, opts: [], branches: []},
            %{transformation: {1, 0, 0}, steps: :infinity, opts: [], branches: []},
            %{transformation: {0, -1, 0}, steps: :infinity, opts: [], branches: []},
            %{transformation: {0, 0, 1}, steps: :infinity, opts: [], branches: []},
            %{transformation: {0, 1, -1}, steps: :infinity, opts: [], branches: []},
            %{transformation: {-1, 1, -1}, steps: :infinity, opts: [], branches: []},
            %{transformation: {1, 0, -1}, steps: :infinity, opts: [], branches: []},
            %{transformation: {0, -1, -1}, steps: :infinity, opts: [], branches: []},
            %{transformation: {-1, -1, 0}, steps: :infinity, opts: [], branches: []},
            %{transformation: {1, 1, 0}, steps: :infinity, opts: [], branches: []},
            %{transformation: {-1, -1, 0}, steps: :infinity, opts: [], branches: []},
            %{transformation: {1, -1, 0}, steps: :infinity, opts: [], branches: []},
            %{transformation: {0, 1, 1}, steps: :infinity, opts: [], branches: []},
            %{transformation: {-1, 0, 1}, steps: :infinity, opts: [], branches: []},
            %{transformation: {1, 0, 1}, steps: :infinity, opts: [], branches: []},
            %{transformation: {0, -1, 1}, steps: :infinity, opts: [], branches: []},
            %{transformation: {-1, 1, -1}, steps: :infinity, opts: [], branches: []},
            %{transformation: {1, 1, -1}, steps: :infinity, opts: [], branches: []},
            %{transformation: {-1, -1, -1}, steps: :infinity, opts: [], branches: []},
            %{transformation: {1, -1, -1}, steps: :infinity, opts: [], branches: []},
            %{transformation: {-1, 1, 1}, steps: :infinity, opts: [], branches: []},
            %{transformation: {1, 1, 1}, steps: :infinity, opts: [], branches: []},
            %{transformation: {-1, -1, 1}, steps: :infinity, opts: [], branches: []},
            %{transformation: {1, -1, 1}, steps: :infinity, opts: [], branches: []}
          ]
        },
        king: %{
          abbreviation: "u",
          opts: [is_king: true],
          movement: [
            %{transformation: {0, 0, -1}, steps: 1, opts: [], branches: []},
            %{transformation: {0, 1, 0}, steps: 1, opts: [], branches: []},
            %{transformation: {-1, 0, 0}, steps: 1, opts: [], branches: []},
            %{transformation: {1, 0, 0}, steps: 1, opts: [], branches: []},
            %{transformation: {0, -1, 0}, steps: 1, opts: [], branches: []},
            %{transformation: {0, 0, 1}, steps: 1, opts: [], branches: []},
            %{transformation: {0, 1, -1}, steps: 1, opts: [], branches: []},
            %{transformation: {-1, 1, -1}, steps: 1, opts: [], branches: []},
            %{transformation: {1, 0, -1}, steps: 1, opts: [], branches: []},
            %{transformation: {0, -1, -1}, steps: 1, opts: [], branches: []},
            %{transformation: {-1, -1, 0}, steps: 1, opts: [], branches: []},
            %{transformation: {1, 1, 0}, steps: 1, opts: [], branches: []},
            %{transformation: {-1, -1, 0}, steps: 1, opts: [], branches: []},
            %{transformation: {1, -1, 0}, steps: 1, opts: [], branches: []},
            %{transformation: {0, 1, 1}, steps: 1, opts: [], branches: []},
            %{transformation: {-1, 0, 1}, steps: 1, opts: [], branches: []},
            %{transformation: {1, 0, 1}, steps: 1, opts: [], branches: []},
            %{transformation: {0, -1, 1}, steps: 1, opts: [], branches: []},
            %{transformation: {-1, 1, -1}, steps: 1, opts: [], branches: []},
            %{transformation: {1, 1, -1}, steps: 1, opts: [], branches: []},
            %{transformation: {-1, -1, -1}, steps: 1, opts: [], branches: []},
            %{transformation: {1, -1, -1}, steps: 1, opts: [], branches: []},
            %{transformation: {-1, 1, 1}, steps: 1, opts: [], branches: []},
            %{transformation: {1, 1, 1}, steps: 1, opts: [], branches: []},
            %{transformation: {-1, -1, 1}, steps: 1, opts: [], branches: []},
            %{transformation: {1, -1, 1}, steps: 1, opts: [], branches: []}
          ]
        }
      },
      piece_info: %{
        pawn1: %{
          owner: 1,
          behavior: :pawn,
          value: 3,
          color: 0xD4AF37,
          model: "TetrahedronGeometry( 0.5 )",
          orientation: %{up: {0, 0, 1}, facing: {0, 1, 0}}
        },
        pawn2: %{
          owner: 1,
          behavior: :pawn,
          value: 3,
          color: 0xD4AF37,
          model: "TetrahedronGeometry( 0.5 )",
          orientation: %{up: {0, 0, 1}, facing: {0, 1, 0}}
        },
        pawn3: %{
          owner: 1,
          behavior: :pawn,
          value: 3,
          color: 0xD4AF37,
          model: "TetrahedronGeometry( 0.5 )",
          orientation: %{up: {0, 0, 1}, facing: {0, 1, 0}}
        },
        pawn4: %{
          owner: 1,
          behavior: :pawn,
          color: 0xD4AF37,
          value: 3,
          model: "TetrahedronGeometry( 0.5 )",
          orientation: %{up: {0, 0, 1}, facing: {0, 1, 0}}
        },
        pawn5: %{
          owner: 1,
          behavior: :pawn,
          color: 0xD4AF37,
          value: 3,
          model: "TetrahedronGeometry( 0.5 )",
          orientation: %{up: {0, 0, 1}, facing: {0, 1, 0}}
        },
        pawn6: %{
          owner: 1,
          behavior: :pawn,
          color: 0xD4AF37,
          value: 3,
          model: "TetrahedronGeometry( 0.5 )",
          orientation: %{up: {0, 0, 1}, facing: {0, 1, 0}}
        },
        pawn7: %{
          owner: 1,
          behavior: :pawn,
          color: 0xD4AF37,
          value: 3,
          model: "TetrahedronGeometry( 0.5 )",
          orientation: %{up: {0, 0, 1}, facing: {0, 1, 0}}
        },
        pawn8: %{
          owner: 1,
          behavior: :pawn,
          color: 0xD4AF37,
          value: 3,
          model: "TetrahedronGeometry( 0.5 )",
          orientation: %{up: {0, 0, 1}, facing: {0, 1, 0}}
        },
        pawn9: %{
          owner: 1,
          behavior: :pawn,
          color: 0xD4AF37,
          value: 3,
          model: "TetrahedronGeometry( 0.5 )",
          orientation: %{up: {0, 0, 1}, facing: {0, 1, 0}}
        },
        pawn10: %{
          owner: 1,
          behavior: :pawn,
          color: 0xD4AF37,
          value: 3,
          model: "TetrahedronGeometry( 0.5 )",
          orientation: %{up: {0, 0, 1}, facing: {0, 1, 0}}
        },
        rook1: %{
          owner: 1,
          behavior: :rook,
          color: 0xD4AF37,
          value: 12,
          model: "BoxGeometry( 0.5, 0.5, 0.5 )",
          orientation: %{up: {0, 0, 1}, facing: {0, 1, 0}}
        },
        rook2: %{
          owner: 1,
          behavior: :rook,
          color: 0xD4AF37,
          value: 12,
          model: "BoxGeometry( 0.5, 0.5, 0.5 )",
          orientation: %{up: {0, 0, 1}, facing: {0, 1, 0}}
        },
        knight1: %{
          owner: 1,
          behavior: :knight,
          color: 0xD4AF37,
          value: 24,
          model: "IcosahedronGeometry( 0.45 )",
          orientation: %{up: {0, 0, 1}, facing: {0, 1, 0}}
        },
        knight2: %{
          owner: 1,
          behavior: :knight,
          color: 0xD4AF37,
          value: 24,
          model: "IcosahedronGeometry( 0.45 )",
          orientation: %{up: {0, 0, 1}, facing: {0, 1, 0}}
        },
        bishop1: %{
          owner: 1,
          behavior: :bishop,
          color: 0xD4AF37,
          value: 22,
          model: "OctahedronGeometry( 0.5 )",
          orientation: %{up: {0, 0, 1}, facing: {0, 1, 0}}
        },
        bishop2: %{
          owner: 1,
          behavior: :bishop,
          color: 0xD4AF37,
          value: 22,
          model: "OctahedronGeometry( 0.5 )",
          orientation: %{up: {0, 0, 1}, facing: {0, 1, 0}}
        },
        unicorn1: %{
          owner: 1,
          behavior: :unicorn,
          color: 0xD4AF37,
          value: 16,
          model: "ConeGeometry(0.3, 0.8, 15 )",
          orientation: %{up: {0, 0, 1}, facing: {0, 1, 0}}
        },
        unicorn2: %{
          owner: 1,
          behavior: :unicorn,
          color: 0xD4AF37,
          value: 16,
          model: "ConeGeometry(0.3, 0.8, 15 )",
          orientation: %{up: {0, 0, 1}, facing: {0, 1, 0}}
        },
        king1: %{
          owner: 1,
          behavior: :king,
          color: 0xD4AF37,
          value: 100_024,
          model: "TorusGeometry(0.3, 0.15, 15, 15 )",
          orientation: %{up: {0, 0, 1}, facing: {0, 1, 0}}
        },
        queen1: %{
          owner: 1,
          behavior: :queen,
          color: 0xD4AF37,
          value: 48,
          model: "SphereGeometry( 0.4, 15, 15)",
          orientation: %{up: {0, 0, 1}, facing: {0, 1, 0}}
        },
        pawn11: %{
          owner: :player2,
          behavior: :pawn,
          value: 3,
          color: 0xC7D1DA,
          model: "TetrahedronGeometry( 0.5 )",
          orientation: %{up: {0, 0, -1}, facing: {0, -1, 0}}
        },
        pawn12: %{
          owner: 2,
          behavior: :pawn,
          value: 3,
          color: 0xC7D1DA,
          model: "TetrahedronGeometry( 0.5 )",
          orientation: %{up: {0, 0, -1}, facing: {0, -1, 0}}
        },
        pawn13: %{
          owner: 2,
          behavior: :pawn,
          value: 3,
          color: 0xC7D1DA,
          model: "TetrahedronGeometry( 0.5 )",
          orientation: %{up: {0, 0, -1}, facing: {0, -1, 0}}
        },
        pawn14: %{
          owner: 2,
          behavior: :pawn,
          value: 3,
          color: 0xC7D1DA,
          model: "TetrahedronGeometry( 0.5 )",
          orientation: %{up: {0, 0, -1}, facing: {0, -1, 0}}
        },
        pawn15: %{
          owner: 2,
          behavior: :pawn,
          value: 3,
          color: 0xC7D1DA,
          model: "TetrahedronGeometry( 0.5 )",
          orientation: %{up: {0, 0, -1}, facing: {0, -1, 0}}
        },
        pawn16: %{
          owner: 2,
          behavior: :pawn,
          value: 3,
          color: 0xC7D1DA,
          model: "TetrahedronGeometry( 0.5 )",
          orientation: %{up: {0, 0, -1}, facing: {0, -1, 0}}
        },
        pawn17: %{
          owner: 2,
          behavior: :pawn,
          value: 3,
          color: 0xC7D1DA,
          model: "TetrahedronGeometry( 0.5 )",
          orientation: %{up: {0, 0, -1}, facing: {0, -1, 0}}
        },
        pawn18: %{
          owner: 2,
          behavior: :pawn,
          value: 3,
          color: 0xC7D1DA,
          model: "TetrahedronGeometry( 0.5 )",
          orientation: %{up: {0, 0, -1}, facing: {0, -1, 0}}
        },
        pawn19: %{
          owner: 2,
          behavior: :pawn,
          value: 3,
          color: 0xC7D1DA,
          model: "TetrahedronGeometry( 0.5 )",
          orientation: %{up: {0, 0, -1}, facing: {0, -1, 0}}
        },
        pawn20: %{
          owner: 2,
          behavior: :pawn,
          value: 3,
          color: 0xC7D1DA,
          model: "TetrahedronGeometry( 0.5 )",
          orientation: %{up: {0, 0, -1}, facing: {0, -1, 0}}
        },
        rook3: %{
          owner: 2,
          behavior: :rook,
          color: 0xC7D1DA,
          value: 12,
          model: "BoxGeometry( 0.5, 0.5, 0.5 )",
          orientation: %{up: {0, 0, -1}, facing: {0, -1, 0}}
        },
        rook4: %{
          owner: 2,
          behavior: :rook,
          color: 0xC7D1DA,
          value: 12,
          model: "BoxGeometry( 0.5, 0.5, 0.5 )",
          orientation: %{up: {0, 0, -1}, facing: {0, -1, 0}}
        },
        knight3: %{
          owner: 2,
          behavior: :knight,
          color: 0xC7D1DA,
          value: 24,
          model: "IcosahedronGeometry( 0.45 )",
          orientation: %{up: {0, 0, -1}, facing: {0, -1, 0}}
        },
        knight4: %{
          owner: 2,
          behavior: :knight,
          color: 0xC7D1DA,
          value: 24,
          model: "IcosahedronGeometry( 0.45 )",
          orientation: %{up: {0, 0, -1}, facing: {0, -1, 0}}
        },
        bishop3: %{
          owner: 2,
          behavior: :bishop,
          color: 0xC7D1DA,
          value: 22,
          model: "OctahedronGeometry( 0.5 )",
          orientation: %{up: {0, 0, -1}, facing: {0, -1, 0}}
        },
        bishop4: %{
          owner: 2,
          behavior: :bishop,
          color: 0xC7D1DA,
          value: 22,
          model: "OctahedronGeometry( 0.5 )",
          orientation: %{up: {0, 0, -1}, facing: {0, -1, 0}}
        },
        unicorn3: %{
          owner: 2,
          behavior: :unicorn,
          color: 0xC7D1DA,
          value: 16,
          model: "ConeGeometry(0.3, 0.8, 15 )",
          orientation: %{up: {0, 0, -1}, facing: {0, -1, 0}}
        },
        unicorn4: %{
          owner: 2,
          behavior: :unicorn,
          color: 0xC7D1DA,
          value: 16,
          model: "ConeGeometry(0.3, 0.8, 15 )",
          orientation: %{up: {0, 0, -1}, facing: {0, -1, 0}}
        },
        king2: %{
          owner: 2,
          behavior: :king,
          color: 0xC7D1DA,
          value: 100_024,
          model: "TorusGeometry(0.3, 0.15, 15, 15 )",
          orientation: %{up: {0, 0, -1}, facing: {0, -1, 0}}
        },
        queen2: %{
          owner: 2,
          behavior: :queen,
          color: 0xC7D1DA,
          value: 48,
          model: "SphereGeometry( 0.4, 15, 15)",
          orientation: %{up: {0, 0, -1}, facing: {0, -1, 0}}
        }
      },
      board: %{
        {2, 4, 4} => :pawn17,
        {5, 5, 3} => :empty,
        {2, 2, 4} => :empty,
        {3, 5, 2} => :empty,
        {4, 1, 4} => :empty,
        {3, 2, 3} => :empty,
        {3, 3, 2} => :empty,
        {1, 5, 4} => :unicorn3,
        {4, 2, 2} => :pawn9,
        {2, 5, 5} => :knight3,
        {3, 4, 5} => :pawn13,
        {4, 2, 3} => :empty,
        {3, 5, 5} => :king2,
        {4, 5, 1} => :empty,
        {2, 1, 3} => :empty,
        {4, 3, 4} => :empty,
        {2, 3, 1} => :empty,
        {1, 2, 2} => :pawn6,
        {4, 1, 2} => :bishop2,
        {1, 1, 4} => :empty,
        {4, 4, 3} => :empty,
        {2, 4, 1} => :empty,
        {2, 4, 5} => :pawn12,
        {3, 4, 3} => :empty,
        {3, 4, 2} => :empty,
        {3, 4, 1} => :empty,
        {4, 4, 1} => :empty,
        {4, 1, 3} => :empty,
        {1, 2, 4} => :empty,
        {1, 5, 2} => :empty,
        {3, 3, 5} => :empty,
        {2, 3, 3} => :empty,
        {2, 2, 1} => :pawn2,
        {1, 2, 1} => :pawn1,
        {5, 5, 5} => :rook4,
        {5, 5, 1} => :empty,
        {5, 3, 5} => :empty,
        {3, 2, 5} => :empty,
        {2, 4, 3} => :empty,
        {3, 5, 4} => :queen2,
        {5, 5, 4} => :bishop4,
        {3, 5, 3} => :empty,
        {2, 5, 2} => :empty,
        {1, 4, 4} => :pawn16,
        {1, 5, 1} => :empty,
        {1, 3, 1} => :empty,
        {2, 1, 4} => :empty,
        {4, 3, 3} => :empty,
        {5, 1, 4} => :empty,
        {5, 4, 1} => :empty,
        {2, 2, 5} => :empty,
        {5, 1, 2} => :unicorn2,
        {3, 1, 5} => :empty,
        {2, 3, 4} => :empty,
        {4, 2, 5} => :empty,
        {4, 1, 5} => :empty,
        {3, 3, 3} => :empty,
        {5, 2, 1} => :pawn5,
        {1, 3, 3} => :empty,
        {5, 2, 4} => :empty,
        {5, 4, 3} => :empty,
        {5, 4, 5} => :pawn15,
        {3, 2, 1} => :pawn3,
        {3, 1, 2} => :queen1,
        {1, 1, 2} => :bishop1,
        {5, 3, 4} => :empty,
        {4, 3, 1} => :empty,
        {5, 2, 2} => :pawn10,
        {2, 2, 2} => :pawn7,
        {2, 1, 2} => :unicorn1,
        {1, 4, 1} => :empty,
        {5, 3, 3} => :empty,
        {3, 1, 4} => :empty,
        {2, 2, 3} => :empty,
        {4, 2, 4} => :empty,
        {2, 5, 4} => :bishop3,
        {3, 5, 1} => :empty,
        {5, 3, 2} => :empty,
        {5, 1, 1} => :rook2,
        {4, 2, 1} => :pawn4,
        {1, 1, 3} => :empty,
        {5, 3, 1} => :empty,
        {1, 3, 2} => :empty,
        {2, 1, 5} => :empty,
        {1, 4, 2} => :empty,
        {5, 1, 3} => :empty,
        {4, 4, 4} => :pawn19,
        {1, 3, 4} => :empty,
        {4, 4, 5} => :pawn14,
        {4, 5, 4} => :unicorn4,
        {5, 4, 4} => :pawn20,
        {3, 4, 4} => :pawn18,
        {1, 1, 1} => :rook1,
        {3, 1, 1} => :king1,
        {1, 3, 5} => :empty,
        {5, 4, 2} => :empty,
        {2, 5, 1} => :empty,
        {4, 1, 1} => :knight2,
        {3, 2, 2} => :pawn8,
        {1, 2, 5} => :empty,
        {3, 3, 4} => :empty,
        {5, 1, 5} => :empty,
        {2, 3, 2} => :empty,
        {1, 5, 3} => :empty,
        {4, 5, 2} => :empty,
        {4, 3, 2} => :empty,
        {1, 5, 5} => :rook3,
        {1, 4, 5} => :pawn11,
        {3, 3, 1} => :empty,
        {5, 2, 5} => :empty,
        {1, 4, 3} => :empty,
        {4, 5, 5} => :knight4,
        {2, 5, 3} => :empty,
        {2, 1, 1} => :knight1,
        {3, 1, 3} => :empty,
        {5, 5, 2} => :empty,
        {5, 2, 3} => :empty,
        {3, 2, 4} => :empty,
        {4, 5, 3} => :empty,
        {4, 3, 5} => :empty,
        {2, 3, 5} => :empty,
        {4, 4, 2} => :empty,
        {1, 2, 3} => :empty,
        {1, 1, 5} => :empty,
        {2, 4, 2} => :empty
      },
      moves: %{}
    }
  ]

  # FOR JAVASCRIPT
  @dummy_game_data [
    %{
      game_id: "abc123",
      players: [
        %{id: 2, name: "devin"},
        %{id: 4, name: "bizarro_devin"}
      ],
      turn: 1,
      default_camera_orientation: %{
        player1: %{up: [0, 0, 1], facing: [0, 1, 0]},
        player2: %{up: [0, 0, -1], facing: [0, -1, 0]}
      },
      board_dimensions: %{rows: 5, columns: 5, levels: 5},
      pieces: %{
        rook1: %{
          name: "rook1",
          position: [1, 1, 1],
          moves: [[1, 1, 2], [2, 1, 1], [1, 2, 1]],
          owner: "player1",
          color: 0xD4AF37,
          model: "BoxGeometry( 0.5, 0.5, 0.5 )",
          orientation: %{up: [0, 0, 1], facing: [0, 1, 0]}
        },
        knight1: %{
          name: "knight1",
          position: [2, 1, 1],
          moves: [],
          owner: "player1",
          color: 0xD4AF37,
          model: "IcosahedronGeometry( 0.45 )",
          orientation: %{up: [0, 0, 1], facing: [0, 1, 0]}
        },
        king1: %{
          name: "king1",
          position: [3, 1, 1],
          moves: [],
          owner: "player1",
          color: 0xD4AF37,
          model: "TorusGeometry(0.3, 0.15, 15, 15 )",
          orientation: %{up: [0, 0, 1], facing: [0, 1, 0]}
        },
        knight2: %{
          name: "knight2",
          position: [4, 1, 1],
          moves: [],
          owner: "player1",
          color: 0xD4AF37,
          model: "IcosahedronGeometry( 0.45 )",
          orientation: %{up: [0, 0, 1], facing: [0, 1, 0]}
        },
        rook2: %{
          name: "rook2",
          position: [5, 1, 1],
          moves: [[5, 1, 2], [4, 1, 1], [5, 2, 1]],
          owner: "player1",
          color: 0xD4AF37,
          model: "BoxGeometry( 0.5, 0.5, 0.5 )",
          orientation: %{up: [0, 0, 1], facing: [0, 1, 0]}
        },
        pawn1: %{
          name: "knight5",
          position: [3, 3, 3],
          moves: [
            [3, 2, 5],
            [4, 3, 5],
            [2, 3, 5],
            [3, 4, 5],
            [3, 1, 4],
            [4, 1, 3],
            [2, 1, 3],
            [3, 1, 2],
            [5, 3, 4],
            [5, 2, 3],
            [5, 4, 3],
            [5, 3, 2],
            [1, 3, 4],
            [1, 2, 3],
            [1, 4, 3],
            [1, 3, 2],
            [3, 5, 4],
            [4, 5, 3],
            [2, 5, 3],
            [3, 5, 2],
            [3, 2, 1],
            [4, 3, 1],
            [2, 3, 1],
            [3, 4, 1]
          ],
          owner: "player1",
          color: 0xD4AF37,
          model: "IcosahedronGeometry( 0.45 )",
          orientation: %{up: [0, 0, 1], facing: [0, 1, 0]}
        },
        pawn2: %{
          name: "pawn2",
          position: [2, 2, 1],
          moves: [],
          owner: "player1",
          color: 0xD4AF37,
          model: "TetrahedronGeometry( 0.5 )",
          orientation: %{up: [0, 0, 1], facing: [0, 1, 0]}
        },
        pawn3: %{
          name: "pawn3",
          position: [3, 2, 1],
          moves: [],
          owner: "player1",
          color: 0xD4AF37,
          model: "TetrahedronGeometry( 0.5 )",
          orientation: %{up: [0, 0, 1], facing: [0, 1, 0]}
        },
        pawn4: %{
          name: "pawn4",
          position: [4, 2, 1],
          moves: [],
          owner: "player1",
          color: 0xD4AF37,
          model: "TetrahedronGeometry( 0.5 )",
          orientation: %{up: [0, 0, 1], facing: [0, 1, 0]}
        },
        pawn5: %{
          name: "pawn5",
          position: [5, 2, 1],
          moves: [],
          owner: "player1",
          color: 0xD4AF37,
          model: "TetrahedronGeometry( 0.5 )",
          orientation: %{up: [0, 0, 1], facing: [0, 1, 0]}
        },
        bishop1: %{
          name: "bishop1",
          position: [1, 1, 2],
          moves: [],
          owner: "player1",
          color: 0xD4AF37,
          model: "OctahedronGeometry( 0.5 )",
          orientation: %{up: [0, 0, 1], facing: [0, 1, 0]}
        },
        unicorn1: %{
          name: "unicorn1",
          position: [2, 1, 2],
          moves: [],
          owner: "player1",
          color: 0xD4AF37,
          model: "ConeGeometry(0.3, 0.8, 15 )",
          orientation: %{up: [0, 0, 1], facing: [0, 1, 0]}
        },
        queen1: %{
          name: "queen1",
          position: [3, 1, 2],
          moves: [],
          owner: "player1",
          color: 0xD4AF37,
          model: "SphereGeometry( 0.4, 15, 15)",
          orientation: %{up: [0, 0, 1], facing: [0, 1, 0]}
        },
        bishop2: %{
          name: "bishop2",
          position: [4, 1, 2],
          moves: [],
          owner: "player1",
          color: 0xD4AF37,
          model: "OctahedronGeometry( 0.5 )",
          orientation: %{up: [0, 0, 1], facing: [0, 1, 0]}
        },
        unicorn2: %{
          name: "unicorn2",
          position: [5, 1, 2],
          moves: [],
          owner: "player1",
          color: 0xD4AF37,
          model: "ConeGeometry(0.3, 0.8, 15 )",
          orientation: %{up: [0, 0, 1], facing: [0, 1, 0]}
        },
        pawn6: %{
          name: "pawn6",
          position: [1, 2, 2],
          moves: [],
          owner: "player1",
          color: 0xD4AF37,
          model: "TetrahedronGeometry( 0.5 )",
          orientation: %{up: [0, 0, 1], facing: [0, 1, 0]}
        },
        pawn7: %{
          name: "pawn7",
          position: [2, 2, 2],
          moves: [],
          owner: "player1",
          color: 0xD4AF37,
          model: "TetrahedronGeometry( 0.5 )",
          orientation: %{up: [0, 0, 1], facing: [0, 1, 0]}
        },
        pawn8: %{
          name: "pawn8",
          position: [3, 2, 2],
          moves: [],
          owner: "player1",
          color: 0xD4AF37,
          model: "TetrahedronGeometry( 0.5 )",
          orientation: %{up: [0, 0, 1], facing: [0, 1, 0]}
        },
        pawn9: %{
          name: "pawn9",
          position: [4, 2, 2],
          moves: [],
          owner: "player1",
          color: 0xD4AF37,
          model: "TetrahedronGeometry( 0.5 )",
          orientation: %{up: [0, 0, 1], facing: [0, 1, 0]}
        },
        pawn10: %{
          name: "pawn10",
          position: [5, 2, 2],
          moves: [],
          owner: "player1",
          color: 0xD4AF37,
          model: "TetrahedronGeometry( 0.5 )",
          orientation: %{up: [0, 0, 1], facing: [0, 1, 0]}
        },
        rook3: %{
          name: "rook3",
          position: [1, 5, 5],
          moves: [],
          owner: "player2",
          color: 0xC7D1DA,
          model: "BoxGeometry( 0.5, 0.5, 0.5 )",
          orientation: %{up: [0, 0, -1], facing: [0, -1, 0]}
        },
        knight3: %{
          name: "knight3",
          position: [2, 5, 5],
          moves: [],
          owner: "player2",
          color: 0xC7D1DA,
          model: "IcosahedronGeometry( 0.45 )",
          orientation: %{up: [0, 0, -1], facing: [0, -1, 0]}
        },
        king2: %{
          name: "king2",
          position: [3, 5, 5],
          moves: [],
          owner: "player2",
          color: 0xC7D1DA,
          model: "TorusGeometry(0.3, 0.15, 15, 15 )",
          orientation: %{up: [0, 0, -1], facing: [0, -1, 0]}
        },
        knight4: %{
          name: "knight4",
          position: [4, 5, 5],
          moves: [],
          owner: "player2",
          color: 0xC7D1DA,
          model: "IcosahedronGeometry( 0.45 )",
          orientation: %{up: [0, 0, -1], facing: [0, -1, 0]}
        },
        rook4: %{
          name: "rook4",
          position: [5, 5, 5],
          moves: [],
          owner: "player2",
          color: 0xC7D1DA,
          model: "BoxGeometry( 0.5, 0.5, 0.5 )",
          orientation: %{up: [0, 0, -1], facing: [0, -1, 0]}
        },
        pawn11: %{
          name: "pawn11",
          position: [1, 4, 5],
          moves: [],
          owner: "player2",
          color: 0xC7D1DA,
          model: "TetrahedronGeometry( 0.5 )",
          orientation: %{up: [0, 0, -1], facing: [0, -1, 0]}
        },
        pawn12: %{
          name: "pawn12",
          position: [2, 4, 5],
          moves: [],
          owner: "player2",
          color: 0xC7D1DA,
          model: "TetrahedronGeometry( 0.5 )",
          orientation: %{up: [0, 0, -1], facing: [0, -1, 0]}
        },
        pawn13: %{
          name: "pawn13",
          position: [3, 4, 5],
          moves: [],
          owner: "player2",
          color: 0xC7D1DA,
          model: "TetrahedronGeometry( 0.5 )",
          orientation: %{up: [0, 0, -1], facing: [0, -1, 0]}
        },
        pawn14: %{
          name: "pawn14",
          position: [4, 4, 5],
          moves: [],
          owner: "player2",
          color: 0xC7D1DA,
          model: "TetrahedronGeometry( 0.5 )",
          orientation: %{up: [0, 0, -1], facing: [0, -1, 0]}
        },
        pawn15: %{
          name: "pawn15",
          position: [5, 4, 5],
          moves: [],
          owner: "player2",
          color: 0xC7D1DA,
          model: "TetrahedronGeometry( 0.5 )",
          orientation: %{up: [0, 0, -1], facing: [0, -1, 0]}
        },
        unicorn3: %{
          name: "unicorn3",
          position: [1, 5, 4],
          moves: [],
          owner: "player2",
          color: 0xC7D1DA,
          model: "ConeGeometry(0.3, 0.8, 15 )",
          orientation: %{up: [0, 0, -1], facing: [0, -1, 0]}
        },
        bishop3: %{
          name: "bishop3",
          position: [2, 5, 4],
          moves: [],
          owner: "player2",
          color: 0xC7D1DA,
          model: "OctahedronGeometry( 0.5 )",
          orientation: %{up: [0, 0, -1], facing: [0, -1, 0]}
        },
        queen2: %{
          name: "queen2",
          position: [3, 5, 4],
          moves: [],
          owner: "player2",
          color: 0xC7D1DA,
          model: "TorusGeometry(0.3, 0.15, 15, 15 )",
          orientation: %{up: [0, 0, -1], facing: [0, -1, 0]}
        },
        unicorn4: %{
          name: "unicorn4",
          position: [4, 5, 4],
          moves: [],
          owner: "player2",
          color: 0xC7D1DA,
          model: "ConeGeometry(0.3, 0.8, 15 )",
          orientation: %{up: [0, 0, -1], facing: [0, -1, 0]}
        },
        bishop4: %{
          name: "bishop4",
          position: [5, 5, 4],
          moves: [],
          owner: "player2",
          color: 0xC7D1DA,
          model: "OctahedronGeometry( 0.5 )",
          orientation: %{up: [0, 0, -1], facing: [0, -1, 0]}
        },
        pawn16: %{
          name: "pawn16",
          position: [1, 4, 4],
          moves: [],
          owner: "player2",
          color: 0xC7D1DA,
          model: "TetrahedronGeometry( 0.5 )",
          orientation: %{up: [0, 0, -1], facing: [0, -1, 0]}
        },
        pawn17: %{
          name: "pawn17",
          position: [2, 4, 4],
          moves: [],
          owner: "player2",
          color: 0xC7D1DA,
          model: "TetrahedronGeometry( 0.5 )",
          orientation: %{up: [0, 0, -1], facing: [0, -1, 0]}
        },
        pawn18: %{
          name: "pawn18",
          position: [3, 4, 4],
          moves: [],
          owner: "player2",
          color: 0xC7D1DA,
          model: "TetrahedronGeometry( 0.5 )",
          orientation: %{up: [0, 0, -1], facing: [0, -1, 0]}
        },
        pawn19: %{
          name: "pawn19",
          position: [4, 4, 4],
          moves: [],
          owner: "player2",
          color: 0xC7D1DA,
          model: "TetrahedronGeometry( 0.5 )",
          orientation: %{up: [0, 0, -1], facing: [0, -1, 0]}
        },
        pawn20: %{
          name: "pawn20",
          position: [5, 4, 4],
          moves: [],
          owner: "player2",
          color: 0xC7D1DA,
          model: "TetrahedronGeometry( 0.5 )",
          orientation: %{up: [0, 0, -1], facing: [0, -1, 0]}
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
    data = Enum.find(@dummy_process_data, fn x -> x.game_id === game_id end)
    data = put_in(data.moves, GameEngine.get_all_moves_of_all_pieces(data))
    GameEngine.create_frontend_data_from_process_data(data)
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
