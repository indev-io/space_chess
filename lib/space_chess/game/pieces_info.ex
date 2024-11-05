defmodule SpaceChess.Game.PiecesInfo do
  @pieces_info %{
    pawn: %{
      abbreviation: :p,
      is_king: false,
      can_promote: true,
      special_promotion: false,
      promotion_pool: [],
      capture_same_as_movement: false,
      movement: %{
        jump: false,
        warp: false,
        backtracking: false,
        forwardtracking: false,
        endpoint_only: true,
        include_midpoints: false,
        fixed_patterns: false,
        pattern: [1],
        resolution: 1,
        matrix: [
          [
            [0, 0, 0],
            [0, 0, 0],
            [0, 0, 0]
          ],
          [
            [0, 1, 0],
            [0, 0, 0],
            [0, 0, 0]
          ],
          [
            [0, 0, 0],
            [0, 1, 0],
            [0, 0, 0]
          ]
        ]
      },
      capture: %{
        jump: false,
        warp: false,
        backtracking: false,
        forwardtracking: false,
        endpoint_only: true,
        include_midpoints: false,
        fixed_patterns: false,
        pattern: [1],
        resolution: 1,
        matrix: [
          [
            [0, 0, 0],
            [0, 0, 0],
            [0, 0, 0]
          ],
          [
            [1, 0, 1],
            [0, 0, 0],
            [0, 0, 0]
          ],
          [
            [0, 0, 0],
            [1, 0, 1],
            [0, 0, 0]
          ]
        ]
      },
      model: "TetrahedronGeometry( 0.5 );"
    }
  }

  def pieces_info do
    @pieces_info
  end
end
