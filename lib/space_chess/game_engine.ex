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
    rook: %{
      abbreviation: "r",
      capture_same_as_movement: true,
      movement: [
        %{transformation: {0, 0, -1}, duration: :infinity, opts: [], branches: []},
        %{transformation: {0, 1, 0}, duration: :infinity, opts: [], branches: []},
        %{transformation: {-1, 0, 0}, duration: :infinity, opts: [], branches: []},
        %{transformation: {1, 0, 0}, duration: :infinity, opts: [], branches: []},
        %{transformation: {0, -1, 0}, duration: :infinity, opts: [], branches: []},
        %{transformation: {0, 0, 1}, duration: :infinity, opts: [], branches: []}
      ]
    },
    knight: %{
      abbreviation: "n",
      capture_same_as_movement: true,
      movement: [
        %{
          transformation: {0, 0, -1},
          duration: 1,
          opts: [dont_record: true, jump: true],
          branches: [
            transformation: {0, 1, 0},
            duration: 2,
            opts: [jump: true, endpoint_only: true],
            branches: [],
            transformation: {-1, 0, 0},
            duration: 2,
            opts: [jump: true, endpoint_only: true],
            branches: [],
            transformation: {1, 0, 0},
            duration: 2,
            opts: [jump: true, endpoint_only: true],
            branches: [],
            transformation: {0, -1, 0},
            duration: 2,
            opts: [jump: true, endpoint_only: true],
            branches: []
          ]
        },
        %{
          transformation: {0, 1, 0},
          duration: 1,
          opts: [dont_record: true, jump: true],
          branches: [
            transformation: {0, 0, -1},
            duration: 2,
            opts: [jump: true, endpoint_only: true],
            branches: [],
            transformation: {-1, 0, 0},
            duration: 2,
            opts: [jump: true, endpoint_only: true],
            branches: [],
            transformation: {1, 0, 0},
            duration: 2,
            opts: [jump: true, endpoint_only: true],
            branches: [],
            transformation: {0, 0, 1},
            duration: 2,
            opts: [jump: true, endpoint_only: true],
            branches: []
          ]
        },
        %{
          transformation: {-1, 0, 0},
          duration: 1,
          opts: [dont_record: true, jump: true],
          branches: [
            transformation: {0, 0, -1},
            duration: 2,
            opts: [jump: true, endpoint_only: true],
            branches: [],
            transformation: {0, 1, 0},
            duration: 2,
            opts: [jump: true, endpoint_only: true],
            branches: [],
            transformation: {0, -1, 0},
            duration: 2,
            opts: [jump: true, endpoint_only: true],
            branches: [],
            transformation: {0, 0, 1},
            duration: 2,
            opts: [jump: true, endpoint_only: true],
            branches: []
          ]
        },
        %{
          transformation: {1, 0, 0},
          duration: 1,
          opts: [dont_record: true, jump: true],
          branches: [
            transformation: {0, 0, -1},
            duration: 2,
            opts: [jump: true, endpoint_only: true],
            branches: [],
            transformation: {0, 1, 0},
            duration: 2,
            opts: [jump: true, endpoint_only: true],
            branches: [],
            transformation: {0, -1, 0},
            duration: 2,
            opts: [jump: true, endpoint_only: true],
            branches: [],
            transformation: {0, 0, 1},
            duration: 2,
            opts: [jump: true, endpoint_only: true],
            branches: []
          ]
        },
        %{
          transformation: {0, -1, 0},
          duration: 1,
          opts: [dont_record: true, jump: true],
          branches: [
            transformation: {0, 0, -1},
            duration: 2,
            opts: [jump: true, endpoint_only: true],
            branches: [],
            transformation: {-1, 0, 0},
            duration: 2,
            opts: [jump: true, endpoint_only: true],
            branches: [],
            transformation: {1, 0, 0},
            duration: 2,
            opts: [jump: true, endpoint_only: true],
            branches: [],
            transformation: {0, 0, 1},
            duration: 2,
            opts: [jump: true, endpoint_only: true],
            branches: []
          ]
        },
        %{
          transformation: {0, 0, 1},
          duration: 1,
          opts: [dont_record: true, jump: true],
          branches: [
            transformation: {0, 1, 0},
            duration: 2,
            opts: [jump: true, endpoint_only: true],
            branches: [],
            transformation: {-1, 0, 0},
            duration: 2,
            opts: [jump: true, endpoint_only: true],
            branches: [],
            transformation: {1, 0, 0},
            duration: 2,
            opts: [jump: true, endpoint_only: true],
            branches: [],
            transformation: {0, -1, 0},
            duration: 2,
            opts: [jump: true, endpoint_only: true],
            branches: []
          ]
        },
        %{
          transformation: {0, 0, -1},
          duration: 2,
          opts: [dont_record: true, jump: true],
          branches: [
            transformation: {0, 1, 0},
            duration: 1,
            opts: [jump: true, endpoint_only: true],
            branches: [],
            transformation: {-1, 0, 0},
            duration: 1,
            opts: [jump: true, endpoint_only: true],
            branches: [],
            transformation: {1, 0, 0},
            duration: 1,
            opts: [jump: true, endpoint_only: true],
            branches: [],
            transformation: {0, -1, 0},
            duration: 1,
            opts: [jump: true, endpoint_only: true],
            branches: []
          ]
        },
        %{
          transformation: {0, 1, 0},
          duration: 2,
          opts: [dont_record: true, jump: true],
          branches: [
            transformation: {0, 0, -1},
            duration: 1,
            opts: [jump: true, endpoint_only: true],
            branches: [],
            transformation: {-1, 0, 0},
            duration: 1,
            opts: [jump: true, endpoint_only: true],
            branches: [],
            transformation: {1, 0, 0},
            duration: 1,
            opts: [jump: true, endpoint_only: true],
            branches: [],
            transformation: {0, 0, 1},
            duration: 1,
            opts: [jump: true, endpoint_only: true],
            branches: []
          ]
        },
        %{
          transformation: {-1, 0, 0},
          duration: 2,
          opts: [dont_record: true, jump: true],
          branches: [
            transformation: {0, 0, -1},
            duration: 1,
            opts: [jump: true, endpoint_only: true],
            branches: [],
            transformation: {0, 1, 0},
            duration: 1,
            opts: [jump: true, endpoint_only: true],
            branches: [],
            transformation: {0, -1, 0},
            duration: 1,
            opts: [jump: true, endpoint_only: true],
            branches: [],
            transformation: {0, 0, 1},
            duration: 1,
            opts: [jump: true, endpoint_only: true],
            branches: []
          ]
        },
        %{
          transformation: {1, 0, 0},
          duration: 2,
          opts: [dont_record: true, jump: true],
          branches: [
            transformation: {0, 0, -1},
            duration: 1,
            opts: [jump: true, endpoint_only: true],
            branches: [],
            transformation: {0, 1, 0},
            duration: 1,
            opts: [jump: true, endpoint_only: true],
            branches: [],
            transformation: {0, -1, 0},
            duration: 1,
            opts: [jump: true, endpoint_only: true],
            branches: [],
            transformation: {0, 0, 1},
            duration: 1,
            opts: [jump: true, endpoint_only: true],
            branches: []
          ]
        },
        %{
          transformation: {0, -1, 0},
          duration: 2,
          opts: [dont_record: true, jump: true],
          branches: [
            transformation: {0, 0, -1},
            duration: 1,
            opts: [jump: true, endpoint_only: true],
            branches: [],
            transformation: {-1, 0, 0},
            duration: 1,
            opts: [jump: true, endpoint_only: true],
            branches: [],
            transformation: {1, 0, 0},
            duration: 1,
            opts: [jump: true, endpoint_only: true],
            branches: [],
            transformation: {0, 0, 1},
            duration: 1,
            opts: [jump: true, endpoint_only: true],
            branches: []
          ]
        },
        %{
          transformation: {0, 0, 1},
          duration: 2,
          opts: [dont_record: true, jump: true],
          branches: [
            transformation: {0, 1, 0},
            duration: 1,
            opts: [jump: true, endpoint_only: true],
            branches: [],
            transformation: {-1, 0, 0},
            duration: 1,
            opts: [jump: true, endpoint_only: true],
            branches: [],
            transformation: {1, 0, 0},
            duration: 1,
            opts: [jump: true, endpoint_only: true],
            branches: [],
            transformation: {0, -1, 0},
            duration: 1,
            opts: [jump: true, endpoint_only: true],
            branches: []
          ]
        }
      ]
    }
  }

  @game_piece_info %{
    rook1: %{owner: :player1, behavior: :rook},
    rook2: %{owner: :player2, behavior: :rook}
  }

  def create_board(rows, columns, levels) do
    Map.new(
      for row <- 1..rows,
          column <- 1..columns,
          level <- 1..levels,
          do: {{row, column, level}, :empty}
    )
  end

  # pieces on board will be :empty or have name which can be used to look up piece_status

  # vector is made of transformation (direction) and count (how many times to repeat that )

  def get_all_moves_of_a_piece(piece_position, piece_behavior, piece_owner, board) do
    piece_matrix = piece_behavior.movement.matrix
    vectors = get_all_vectors_of_a_piece(piece_matrix)
  end

  # piece info map: %{current_position: current_position, vector: %{transformation: {x,y, z}, count: count}, owner: owner, previous_position: {}, opts: [], recorded_spaces: [], record_space: true} }

  def get_full_path_from_vector(piece_info, board) do
  end

  def move_along_entire_path_and_record_spaces({:ok, piece_info}, board) do
  end

  def move_along_vector_path_and_record_spaces({:stop, piece_info}, _board) do
    piece_info.recorded_spaces
  end

  def move_along_vector_path_and_record_spaces({:ok, piece_info}, board) do
    piece_info
    |> move_piece_one_space_along_vector_path(board)
    |> check_if_in_bounds(board)
    |> handle_space(board)
    |> check_if_end_of_vector_path()
    |> handle_record_opts()
    |> maybe_record_space()
    |> move_along_vector_path_and_record_spaces(board)
  end

  defp check_if_in_bounds({:ok, piece_info}, board) do
    if Map.has_key?(board, piece_info.current_position) do
      {:ok, piece_info}
    else
      {:stop, Map.put(piece_info, :piece_position, piece_info.previous_position)}
    end
  end

  defp handle_space({:stop, piece_info}, _board), do: {:stop, piece_info}

  defp handle_space({:ok, piece_info}, board) do
    if Map.get(board, piece_info.current_position) === :empty do
      {:ok, piece_info}
    else
      if can_jump(piece_info) do
        {:ok, Map.put(piece_info, :record_space, false)}
      else
        determine_occupant({:ok, piece_info}, board)
      end
    end
  end

  defp check_if_end_of_vector_path({:stop, piece_info}), do: {:stop, piece_info}

  defp check_if_end_of_vector_path({:ok, piece_info}) do
    if last_move_in_vector?(piece_info) do
      {:stop, piece_info}
    else
      {:ok, piece_info}
    end
  end

  defp determine_occupant({:ok, piece_info}, board) do
    occupant = Map.get(board, piece_info.current_position)

    if piece_info.owner === @game_piece_info[occupant][:owner] do
      {:stop, Map.put(piece_info, :piece_position, piece_info.previous_position)}
    else
      {:stop, piece_info}
    end
  end

  defp handle_record_opts({:stop, piece_info}) do
    cond do
      Keyword.has_key?(piece_info.opts, :dont_record) ->
        {:ok, Map.put(piece_info, :record_space, false)}

      Keyword.has_key?(piece_info.opts, :endpoint_only) ->
        check_if_endpoint(piece_info)

      true ->
        {:stop, piece_info}
    end
  end

  defp handle_record_opts({:ok, piece_info}) do
    cond do
      Keyword.has_key?(piece_info.opts, :dont_record) ->
        {:ok, Map.put(piece_info, :record_space, false)}

      Keyword.has_key?(piece_info.opts, :resolution) ->
        check_resolution(piece_info)

      true ->
        {:ok, piece_info}
    end
  end

  defp maybe_record_space({state, piece_info}) do
    if piece_info.record_space do
      previously_recorded_spaces = piece_info.record_spaces

      piece_info =
        Map.put(piece_info, :recorded_spaces, [
          piece_info.current_position | previously_recorded_spaces
        ])

      {state, piece_info}
    else
      {state, piece_info}
    end
  end

  defp check_if_endpoint(piece_info) do
    if last_move_in_vector?(piece_info) do
      {:stop, piece_info}
    else
      {:stop, Map.put(piece_info, :record_space, false)}
    end
  end

  defp check_resolution(piece_info) do
    resolution = Keyword.get(piece_info.opts, :resolution)
    count = piece_info.vector.count

    if rem(count, resolution) === 0 do
      {:ok, piece_info}
    else
      {:ok, Map.put(piece_info, :record_space, false)}
    end
  end

  defp can_jump(piece_info) do
    Keyword.has_key?(piece_info.opts, :jump) and !last_move_in_vector?(piece_info)
  end

  defp last_move_in_vector?(piece_info) do
    piece_info.vector.count === 0
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

  def move_piece_one_space_along_vector_path(piece_info, board) do
    current_position =
      apply_transformation(piece_info.piece_position, piece_info.vector.transformation)

    new_count = decrement_count(piece_info.vector.count)
    new_vector = Map.put(piece_info.vector, :count, new_count)
    piece_info = Map.put(piece_info, :current_position, current_position)
    piece_info = Map.put(piece_info, :vector, new_vector)
    {:ok, piece_info}
  end

  defp decrement_count(:infinity), do: :infinity
  defp decrement_count(count), do: count - 1
end
