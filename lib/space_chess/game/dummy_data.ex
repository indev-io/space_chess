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
end
