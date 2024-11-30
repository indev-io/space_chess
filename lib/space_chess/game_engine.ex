defmodule SpaceChess.GameEngine do
  # ref
  # {0, 0, 0}, {0, 0, 1} ,{0, 0, 2},
  # {0, 1, 0}, {0, 1, 1} ,{0, 1, 2},
  # {0, 2, 0}, {0, 2, 1} ,{0, 2, 2},

  # {1, 0, 0}, {1, 0, 1}, {1, 0, 2},
  # {1, 1, 0}, {1, 1, 1}, {1, 1, 2},
  # {1, 2, 0}, {1, 2, 1}, {1, 2, 2},

  # {2, 0, 0}, {2, 0, 1}, {2, 0, 2},
  # {2, 1, 0}, {2, 1, 1}, {2, 1, 2},
  # {2, 2, 0}, {2, 2, 1}, {2, 2, 2}

  # ref
  # {-1, 1, -1}, {0, 1, -1},  {1, 1, -1},
  # {-1, 0, -1}, {0, 0, -1},  {1, 0, -1},
  # {-1, -1, -1},{0, -1, -1}, {1, -1, -1},

  # {-1, 1, 0}, {0, 1, 0},  {1, 1, 0},
  # {-1, 0, 0}, {0, 0, 0},  {1, 0, 0},
  # {-1, -1, 0},{0, -1, 0}, {1, -1, 0},

  # {-1, 1, 1},{0, 1, 1},{1, 1, 1},
  # {-1, 0, 1},{0, 0, 1},{1, 0, 1},
  # {-1, -1, 1},{0, -1, 1},{1, -1, 1}

  @matrix_to_transformations %{
    {0, 0, 0} => {-1, 1, -1},
    {0, 0, 1} => {0, 1, -1},
    {0, 0, 2} => {1, 1, -1},
    {0, 1, 0} => {-1, 0, -1},
    {0, 1, 1} => {0, 0, -1},
    {0, 1, 2} => {1, 0, -1},
    {0, 2, 0} => {-1, -1, -1},
    {0, 2, 1} => {0, -1, -1},
    {0, 2, 2} => {1, -1, -1},
    {1, 0, 0} => {-1, 1, 0},
    {1, 0, 1} => {0, 1, 0},
    {1, 0, 2} => {1, 1, 0},
    {1, 1, 0} => {-1, 0, 0},
    {1, 1, 1} => {0, 0, 0},
    {1, 1, 2} => {1, 0, 0},
    {1, 2, 0} => {-1, -1, 0},
    {1, 2, 1} => {0, -1, 0},
    {1, 2, 2} => {1, -1, 0},
    {2, 0, 0} => {-1, 1, 1},
    {2, 0, 1} => {0, 1, 1},
    {2, 0, 2} => {1, 1, 1},
    {2, 1, 0} => {-1, 0, 1},
    {2, 1, 1} => {0, 0, 1},
    {2, 1, 2} => {1, 0, 1},
    {2, 2, 0} => {-1, -1, 1},
    {2, 2, 1} => {0, -1, 1},
    {2, 2, 2} => {1, -1, 1}
  }

  def matrix_to_transformations(matrix) do
    Map.get(@matrix_to_transformations, matrix)
  end

  @piece_behavior %{
    pawn: %{
      abbreviation: "p",
      opts: [],
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
          duration: 2,
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
          duration: 2,
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
          duration: 2,
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
          duration: 2,
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
      opts: [],
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
  }

  # ELIXIR SIDE ONLY
  def create_default_setup() do
    board = create_board(5, 5, 5)

    owner = %{
      pawn1: :player1,
      pawn2: :player1,
      pawn3: :player1,
      pawn4: :player1,
      pawn5: :player1,
      pawn6: :player1,
      pawn7: :player1,
      pawn8: :player1,
      pawn9: :player1,
      pawn10: :player1,
      rook1: :player1,
      rook2: :player1,
      knight1: :player1,
      knight2: :player1,
      bishop1: :player1,
      bishop2: :player1,
      unicorn1: :player1,
      unicorn2: :player1,
      king1: :player1,
      queen1: :player1,
      pawn11: :player2,
      pawn12: :player2,
      pawn13: :player2,
      pawn14: :player2,
      pawn15: :player2,
      pawn16: :player2,
      pawn17: :player2,
      pawn18: :player2,
      pawn19: :player2,
      pawn20: :player2,
      rook3: :player2,
      rook4: :player2,
      knight3: :player2,
      knight4: :player2,
      bishop3: :player2,
      bishop4: :player2,
      unicorn3: :player2,
      unicorn4: :player2,
      king2: :player2,
      queen2: :player2
    }

    behavior = %{
      pawn1: :pawn,
      pawn2: :pawn,
      pawn3: :pawn,
      pawn4: :pawn,
      pawn5: :pawn,
      pawn6: :pawn,
      pawn7: :pawn,
      pawn8: :pawn,
      pawn9: :pawn,
      pawn10: :pawn,
      rook1: :rook,
      rook2: :rook,
      knight1: :knight,
      knight2: :knight,
      bishop1: :bishop,
      bishop2: :bishop,
      unicorn1: :unicorn,
      unicorn2: :unicorn,
      king1: :king,
      queen1: :queen,
      pawn11: :pawn,
      pawn12: :pawn,
      pawn13: :pawn,
      pawn14: :pawn,
      pawn15: :pawn,
      pawn16: :pawn,
      pawn17: :pawn,
      pawn18: :pawn,
      pawn19: :pawn,
      pawn20: :pawn,
      rook3: :rook,
      rook4: :rook,
      knight3: :knight,
      knight4: :knight,
      bishop3: :bishop,
      bishop4: :bishop,
      unicorn3: :unicorn,
      unicorn4: :unicorn,
      king2: :king,
      queen2: :queen
    }

    moves = %{
      pawn1: [],
      pawn2: [],
      pawn3: [],
      pawn4: [],
      pawn5: [],
      pawn6: [],
      pawn7: [],
      pawn8: [],
      pawn9: [],
      pawn10: [],
      rook1: [],
      rook2: [],
      knight1: [],
      knight2: [],
      bishop1: [],
      bishop2: [],
      unicorn1: [],
      unicorn2: [],
      king1: [],
      queen1: [],
      pawn11: [],
      pawn12: [],
      pawn13: [],
      pawn14: [],
      pawn15: [],
      pawn16: [],
      pawn17: [],
      pawn18: [],
      pawn19: [],
      pawn20: [],
      rook3: [],
      rook4: [],
      knight3: [],
      knight4: [],
      bishop3: [],
      bishop4: [],
      unicorn3: [],
      unicorn4: [],
      king2: [],
      queen2: []
    }

    looks = %{
      pawn1: "TetrahedronGeometry( 0.5 )",
      pawn2: "TetrahedronGeometry( 0.5 )",
      pawn3: "TetrahedronGeometry( 0.5 )",
      pawn4: "TetrahedronGeometry( 0.5 )",
      pawn5: "TetrahedronGeometry( 0.5 )",
      pawn6: "TetrahedronGeometry( 0.5 )",
      pawn7: "TetrahedronGeometry( 0.5 )",
      pawn8: "TetrahedronGeometry( 0.5 )",
      pawn9: "TetrahedronGeometry( 0.5 )",
      pawn10: "TetrahedronGeometry( 0.5 )",
      rook1: "BoxGeometry( 0.5, 0.5, 0.5 )",
      rook2: "BoxGeometry( 0.5, 0.5, 0.5 )",
      knight1: "IcosahedronGeometry( 0.45 )",
      knight2: "IcosahedronGeometry( 0.45 )",
      bishop1: "OctahedronGeometry( 0.5 )",
      bishop2: "OctahedronGeometry( 0.5 )",
      unicorn1: "ConeGeometry(0.3, 0.8, 15 )",
      unicorn2: "ConeGeometry(0.3, 0.8, 15 )",
      king1: "TorusGeometry(0.3, 0.15, 15, 15 )",
      queen1: "SphereGeometry( 0.4, 15, 15)",
      pawn11: "TetrahedronGeometry( 0.5 )",
      pawn12: "TetrahedronGeometry( 0.5 )",
      pawn13: "TetrahedronGeometry( 0.5 )",
      pawn14: "TetrahedronGeometry( 0.5 )",
      pawn15: "TetrahedronGeometry( 0.5 )",
      pawn16: "TetrahedronGeometry( 0.5 )",
      pawn17: "TetrahedronGeometry( 0.5 )",
      pawn18: "TetrahedronGeometry( 0.5 )",
      pawn19: "TetrahedronGeometry( 0.5 )",
      pawn20: "TetrahedronGeometry( 0.5 )",
      rook3: "BoxGeometry( 0.5, 0.5, 0.5 )",
      rook4: "BoxGeometry( 0.5, 0.5, 0.5 )",
      knight3: "IcosahedronGeometry( 0.45 )",
      knight4: "IcosahedronGeometry( 0.45 )",
      bishop3: "OctahedronGeometry( 0.5 )",
      bishop4: "OctahedronGeometry( 0.5 )",
      unicorn3: "ConeGeometry(0.3, 0.8, 15 )",
      unicorn4: "ConeGeometry(0.3, 0.8, 15 )",
      king2: "TorusGeometry(0.3, 0.15, 15, 15 )",
      queen2: "TorusGeometry(0.3, 0.15, 15, 15 )"
    }

    pieces =
      [
        {{1, 1, 1}, :rook1},
        {{2, 1, 1}, :knight1},
        {{3, 1, 1}, :king1},
        {{4, 1, 1}, :knight2},
        {{5, 1, 1}, :rook2},
        {{1, 2, 1}, :pawn1},
        {{2, 2, 1}, :pawn2},
        {{3, 2, 1}, :pawn3},
        {{4, 2, 1}, :pawn4},
        {{5, 2, 1}, :pawn5},
        {{1, 1, 2}, :bishop1},
        {{2, 1, 2}, :unicorn1},
        {{3, 1, 2}, :queen1},
        {{4, 1, 2}, :bishop2},
        {{5, 1, 2}, :unicorn2},
        {{1, 2, 2}, :pawn6},
        {{2, 2, 2}, :pawn7},
        {{3, 2, 2}, :pawn8},
        {{4, 2, 2}, :pawn9},
        {{5, 2, 2}, :pawn10},
        {{1, 5, 5}, :rook3},
        {{2, 5, 5}, :knight3},
        {{3, 5, 5}, :king2},
        {{4, 5, 5}, :knight4},
        {{5, 5, 5}, :rook4},
        {{1, 4, 5}, :pawn11},
        {{2, 4, 5}, :pawn12},
        {{3, 4, 5}, :pawn13},
        {{4, 4, 5}, :pawn14},
        {{5, 4, 5}, :pawn15},
        {{1, 5, 4}, :unicorn3},
        {{2, 5, 4}, :bishop3},
        {{3, 5, 4}, :queen2},
        {{4, 5, 4}, :unicorn4},
        {{5, 5, 4}, :bishop4},
        {{1, 4, 4}, :pawn16},
        {{2, 4, 4}, :pawn17},
        {{3, 4, 4}, :pawn18},
        {{4, 4, 4}, :pawn19},
        {{5, 4, 4}, :pawn20}
      ]

    board = Enum.reduce(pieces, board, fn {coords, name}, acc -> Map.put(acc, coords, name) end)

    # game object
    %{
      board: board,
      owner: owner,
      moves: moves,
      looks: looks,
      behavior: behavior,
      players: [:player1, :player2],
      turn: 0,
      round: 1,
      status: :waiting_for_players
    }
  end

  def elixir_data_to_JSON(data) do
    Enum.map(data, fn {coords, name} ->
      %{coords: Tuple.to_list(coords), name: Atom.to_string(name)}
    end)
  end

  @game_piece_info %{
    rook1: %{owner: :player1, behavior: :rook, value: 14},
    rook2: %{owner: :player2, behavior: :rook, value: 14}
  }

  # orientation is based off of top-of-head-direction + front-of-face-direction
  # in raumschasch default player 1 orientation is pz_py, default player 2 is nz_ny
  @orientations {
    :pz_py,
    :pz_px,
    :pz_ny,
    :pz_nx,
    :pz_nx
  }

  @game_object %{
    piece_behavior: @piece_behavior,
    piece_info: %{
      rook1: %{owner: :player1, behavior: :rook, value: 14, moves: {}, orientation: :pzpx}
    },
    board: :game_board,
    players: [:player1, :player2],
    status: %{
      winner: nil,
      still_playing: true,
      turn: :player1,
      round: 0
    }
  }

  def create_board(rows, columns, levels) do
    Map.new(
      for row <- 1..rows,
          column <- 1..columns,
          level <- 1..levels,
          do: {{row, column, level}, :empty}
    )
  end

  def create_empty_board_from_board(board) do
    {rows, columns, levels} = get_board_dimensions(board)
    create_board(rows, columns, levels)
  end

  defp get_board_dimensions(board) do
    {board_dimensions, _space_status} = Enum.max(board)
    board_dimensions
  end

  def find_center_of_board_from_board_dimensions(board_dimensions) do
    {rows, columns, levels} = board_dimensions
    {round(rows / 2), round(columns / 2), round(levels / 2)}
  end

  def determine_value_of_piece(piece_behavior, board) do
    movement = piece_behavior.movement

    center_position =
      board
      |> get_board_dimensions()
      |> find_center_of_board_from_board_dimensions()

    capture_movement =
      movement
      |> Enum.filter(fn x -> Keyword.has_key?(x.opts, :capture_only) end)
      |> Enum.map(fn x -> Map.put(x, :opts, Keyword.delete(x.opts, :capture_only)) end)

    movement_only_movement =
      movement
      |> Enum.filter(fn x -> Keyword.has_key?(x.opts, :movement_only) end)
      |> Enum.map(fn x -> Map.put(x, :opts, Keyword.delete(x.opts, :movement_only)) end)

    normal_movement =
      movement
      |> Enum.reject(fn x -> Keyword.has_key?(x.opts, :capture_only) end)
      |> Enum.reject(fn x -> Keyword.has_key?(x.opts, :movement_only) end)

    capture_moves = get_all_moves_of_a_piece(center_position, capture_movement, :default, board)

    movement_only_moves =
      get_all_moves_of_a_piece(center_position, movement_only_movement, :default, board)

    normal_moves = get_all_moves_of_a_piece(center_position, normal_movement, :default, board)

    value = length(capture_moves) / 2 + length(movement_only_moves) / 2 + length(normal_moves)

    value =
      if Keyword.has_key?(piece_behavior.opts, :is_king) do
        value + 100_000
      end

    round(value)
  end

  # WORK ON THIS TOMORROW *************
  def determine_value_of_board(board) do
    {rows, columns, levels} = get_board_dimensions(board)

    # lookup pieces
    # determine how close each piece is to the center (possibly)
    # determine how clsoe each promotional piece is to the promotion zone, calculate based on what that can promote to
  end

  def maxi_max(board, players, turn \\ 1) do
    # user Enum.at to get the player by turn
    # each "level" will contain all possible moves played by player
    # scan board for all pieces
    # create_list_of_pieces controlled by player
    # get_all_moves_of_each_piece
    # generate_all_boards created by each pieces, keeping track of the parent move
    # generate_all_the_boards as long as there is depth
  end

  # **************

  def distance_between_two_points(starting_coords, ending_coords) do
    {x, y, z} = ending_coords
    {a, b, c} = starting_coords
    ((x - a) ** 2 + (y - b) ** 2 + (z - b) ** 2) ** 0.5
  end

  # zone is going to be a list of coords
  def find_nearest_position_in_zone(position, zone) do
    positions_with_distances =
      Enum.map(zone, fn x ->
        %{distance: distance_between_two_points(position, x), position: x}
      end)

    [result | _tail] = Enum.sort_by(positions_with_distances, fn x -> x.distance end, :asc)
    result.position
  end

  # pieces on board will be :empty or have name which can be used to look up piece_status

  # vector is made of transformation (direction) and count (how many times to repeat that )

  def get_all_moves_of_a_piece(piece_position, movement, piece_name, board) do
    moves =
      Enum.reduce(movement, [], fn branch, acc ->
        new_moves =
          move_along_branch_and_record_moves(true, branch, piece_position, piece_name, board, [])

        [new_moves | acc]
      end)

    moves
    |> List.flatten()
    |> Enum.uniq()
  end

  # a path is the connection of multiple branches -> path: branch -- branch --- branch
  def move_along_branch_and_record_moves(
        true,
        movement_map,
        piece_position,
        piece_name,
        board,
        moves \\ []
      )
      when movement_map.steps > 0 do
    movement_map = Map.put(movement_map, :steps, decrement_steps(movement_map.steps))
    piece_position = apply_transformation(piece_position, movement_map.transformation)

    {continue_path, record_move, _no_capture} =
      {true, true, true}
      |> check_in_bounds(board, piece_position)
      |> check_status_of_space(board, movement_map, piece_position, piece_name)
      |> check_recording_opts(movement_map)
      |> check_if_final_move_in_path(movement_map)

    moves = maybe_record_move(record_move, piece_position, moves)

    move_along_branch_and_record_moves(
      continue_path,
      movement_map,
      piece_position,
      piece_name,
      board,
      moves
    )
  end

  def move_along_branch_and_record_moves(
        true,
        movement_map,
        piece_position,
        piece_name,
        board,
        moves
      ) do
    if length(movement_map.branches) > 0 do
      Enum.reduce(movement_map.branches, moves, fn branch, acc ->
        new_moves =
          move_along_branch_and_record_moves(
            true,
            branch,
            piece_position,
            piece_name,
            board,
            moves
          )

        [new_moves | acc]
      end)
    else
      move_along_branch_and_record_moves(
        false,
        movement_map,
        piece_position,
        piece_name,
        board,
        moves
      )
    end
  end

  def move_along_branch_and_record_moves(
        false,
        _movement_map,
        _piece_position,
        _piece_name,
        _board,
        moves
      ) do
    moves
  end

  defp maybe_record_move(record_move, piece_position, moves) do
    if record_move do
      [piece_position | moves]
    else
      moves
    end
  end

  defp check_if_final_move_in_path({continue_path, record_move, no_capture}, movement_map) do
    if movement_map.steps == 0 and length(movement_map.branches) == 0 do
      {false, record_move, no_capture}
    else
      {continue_path, record_move, no_capture}
    end
  end

  defp check_in_bounds({continue_path, record_move, no_capture}, board, position) do
    if !Map.has_key?(board, position) do
      {false, false, no_capture}
    else
      {continue_path, record_move, no_capture}
    end
  end

  def check_status_of_space(
        {continue_path, record_move, no_capture},
        board,
        movement_map,
        piece_position,
        piece_name
      ) do
    space = Map.get(board, piece_position)

    if space === :empty do
      {continue_path, record_move, no_capture}
    else
      {continue_path, record_move, no_capture}
      |> check_movement_only(movement_map)
      |> check_jump(movement_map)
      |> check_if_friendly(piece_name, space, @game_piece_info)
    end
  end

  defp check_jump({continue_path, record_move, no_capture}, movement_map) do
    if Keyword.has_key?(movement_map.opts, :jump) do
      {continue_path, record_move, no_capture}
    else
      {false, record_move, no_capture}
    end
  end

  defp check_movement_only({continue_path, record_move, no_capture}, movement_map) do
    if Keyword.has_key?(movement_map.opts, :movement_only) do
      {continue_path, false, no_capture}
    else
      {continue_path, record_move, no_capture}
    end
  end

  defp check_if_friendly(
         {continue_path, record_move, no_capture},
         piece_name,
         space,
         game_piece_info
       ) do
    if game_piece_info[space][:owner] === game_piece_info[piece_name][:owner] do
      {continue_path, false, no_capture}
    else
      {continue_path, record_move, false}
    end
  end

  def check_recording_opts({continue_path, record_move, no_capture}, movement_map) do
    opts = movement_map.opts

    {continue_path, record_move, no_capture}
    |> check_dont_record(opts)
    |> check_endpoint_only(opts)
    |> check_resolution(opts)
    |> check_capture_only(opts)
  end

  defp check_dont_record({continue_path, record_move, no_capture}, opts) do
    if Keyword.has_key?(opts, :dont_record) do
      {continue_path, false, no_capture}
    else
      {continue_path, record_move, no_capture}
    end
  end

  defp check_endpoint_only({continue_path, record_move, no_capture}, opts) do
    if Keyword.has_key?(opts, :endpoint_only) and opts.steps != 0 do
      {continue_path, false, no_capture}
    else
      {continue_path, record_move, no_capture}
    end
  end

  defp check_resolution({continue_path, record_move, no_capture}, opts) do
    if Keyword.has_key?(opts, :resolution) and
         rem(opts.steps, opts[:resolution]) != 0 do
      {continue_path, false, no_capture}
    else
      {continue_path, record_move, no_capture}
    end
  end

  defp check_capture_only({continue_path, record_move, no_capture}, opts) do
    if Keyword.has_key?(opts, :capture_only) and no_capture do
      {continue_path, false, no_capture}
    else
      {continue_path, record_move, no_capture}
    end
  end

  # returns a list of tuples (transformations), with home many times to apply them
  def get_all_vectors_of_a_piece(matrix) do
    Enum.map(matrix, fn {a, b} -> {Map.get(@matrix_to_transformations, a), b} end)
  end

  def apply_transformation(piece_position, transformation) do
    {a, b, c} = piece_position
    {x, y, z} = transformation
    {a + x, b + y, c + z}
  end

  defp decrement_steps(:infinity), do: :infinity
  defp decrement_steps(steps), do: steps - 1

  def rotate_90_degrees_clockwise_along_x_axis(coordinates) do
    {x, y, z} = coordinates
    {x, -z, y}
  end

  def rotate_90_degrees_counterclockwise_along_x_axis(coordinates) do
    {x, y, z} = coordinates
    {x, z, -y}
  end

  def rotate_90_degrees_clockwise_along_y_axis(coordinates) do
    {x, y, z} = coordinates
    {-z, y, x}
  end

  def rotate_90_degrees_counterclockwise_along_y_axis(coordinates) do
    {x, y, z} = coordinates
    {z, y, -x}
  end

  def rotate_90_degrees_clockwise_along_z_axis(coordinates) do
    {x, y, z} = coordinates
    {y, -x, z}
  end

  def rotate_90_degrees_counterclockwise_along_z_axis(coordinates) do
    {x, y, z} = coordinates
    {-y, x, z}
  end
end
