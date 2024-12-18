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

  # ELIXIR SIDE ONLY


  #work in progress
  def create_frontend_data_from_process_data(game_obj) do
    pieces = Enum.reduce(game_obj.board, %{}, fn {position, value}, acc ->
      if value === :empty do
      acc
      else
        {x, y, z} = position
        %{up: {up_x, up_y, up_z}, facing: {facing_x, facing_y, facing_z}} =
          game_obj.piece_info[value].orientation
        piece_obj = %{
          name: value,
          position: [x, y, z],
          owner: game_obj.piece_info[value].owner,
          color: game_obj.piece_info[value].color,
          moves: Enum.map(game_obj.moves[value], fn {x, y, z} -> [x, y, z] end),
          model: game_obj.piece_info[value].model,
          orientation: %{up: [up_x, up_y, up_z], facing: [facing_x, facing_y, facing_z]}
        }
        Map.put(acc, value, piece_obj)
      end
    end)

    players = Enum.map(game_obj.players, fn {_num, obj} -> obj end)
    promotion_zones = Enum.map(game_obj.promotion_zones, fn {_key, value} ->
      Enum.map(value, fn {x, y, z} -> [x, y, z] end)
    end)
    game_obj
    |> Map.put(:pieces, pieces)
    |> Map.put(:players, players)
    |> Map.put(:promotion_zones, promotion_zones)
    |> Map.delete(:moves)
    |> Map.delete(:piece_info)
    |> Map.delete(:piece_behavior)
    |> Map.delete(:board)

  end

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

  def get_board_dimensions(board) do
    {board_dimensions, _space_status} = Enum.max(board)
    board_dimensions
  end

  def find_center_of_board_from_board_dimensions(board_dimensions) do
    {rows, columns, levels} = board_dimensions
    {round(rows / 2), round(columns / 2), round(levels / 2)}
  end

  # adds a bonus points to pawns
  def find_closeness_value_of_promotable_piece(piece_position, game_obj) do
    {_name, piece_obj} = highest_possible_promotion_option(game_obj)
    name = game_obj.board[piece_position]
    owner = game_obj.piece_info[name][:owner]
    promotion_zone = game_obj.promotion_zones[owner]
    promoted_value = piece_obj.value

    nearest_promotion_zone_position =
      find_nearest_position_in_zone(piece_position, promotion_zone)

    distance = distance_between_two_points(piece_position, nearest_promotion_zone_position)

    starting_distance = 4.243

    closeness = 1 - distance / starting_distance
    # as closeness approaches 1, value becomes highest value
    closeness_multiplier = 0.125
    promoted_value * closeness * closeness_multiplier
  end

  def highest_possible_promotion_option(game_obj) do
    piece_info = game_obj.piece_info
    piece_behavior = game_obj.piece_behavior

    piece_info
    |> Enum.reject(fn {_key, value} ->
      Keyword.has_key?(piece_behavior[value.behavior][:opts], :is_king)
    end)
    |> Enum.max_by(fn {_key, value} -> value.value end)
  end

  ## RUN THIS ON SETUP
  def determine_value_of_piece(piece_name, game_obj) do
    behavior = game_obj.piece_info[piece_name].behavior
    movement = game_obj.piece_behavior[behavior].movement

    center_position =
      game_obj.board
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

    capture_game_obj = put_in(game_obj.piece_behavior[behavior].movement, capture_movement)
    capture_moves = get_all_moves_of_a_piece(piece_name, center_position, capture_game_obj)

    movement_game_obj = put_in(game_obj.piece_behavior[behavior].movement, movement_only_movement)
    movement_only_moves = get_all_moves_of_a_piece(piece_name, center_position, movement_game_obj)

    normal_game_obj = put_in(game_obj.piece_behavior[behavior].movement, normal_movement)
    normal_moves = get_all_moves_of_a_piece(piece_name, center_position, normal_game_obj)

    value = length(capture_moves) / 2 + length(movement_only_moves) / 2 + length(normal_moves)

    value =
      if Keyword.has_key?(game_obj.piece_behavior[behavior].opts, :is_king) do
        value + 100_000
      else
        value
      end

    round(value)
  end

  def next_turn(game_obj) do
    turn = game_obj.turn + 1
    num_players = map_size(game_obj.players)
    round = game_obj.round

    if turn > num_players do
      game_obj
      |> Map.put(:turn, 1)
      |> Map.put(:round, round + 1)
    else
      Map.put(game_obj, :turn, turn)
    end
  end

  def determine_value_of_board(game_obj) do
    board = game_obj.board

    Enum.reduce(board, 0, fn {_key, value}, acc ->
      if value === :empty do
        acc
      else
        IO.inspect(game_obj.piece_info[value])
        if game_obj.piece_info[value][:owner] === game_obj.turn do
          acc + game_obj.piece_info[value][:value]
        else
          acc - game_obj.piece_info[value][:value]
        end
      end
    end)

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
    ((x - a) ** 2 + (y - b) ** 2 + (z - c) ** 2) ** 0.5
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

  def get_all_moves_of_all_pieces(game_obj) do
    board = game_obj.board

    Enum.reduce(board, %{}, fn {piece_position, piece_name}, acc ->
      if piece_name === :empty do
        acc
      else
        moves = get_all_moves_of_a_piece(piece_name, piece_position, game_obj)
        Map.put(acc, piece_name, moves)
      end
    end)
  end

  # def puts_piece_in_danger?(gameObj) do
  #   moves = get_all_moves_of_all_pieces(gameObj)
  # end

  # pieces on board will be :empty or have name which can be used to look up piece_status

  def get_all_moves_of_a_piece(piece_name, piece_position, game_obj) do
    behavior = game_obj.piece_info[piece_name][:behavior]
    movement = game_obj.piece_behavior[behavior][:movement]

    movement = rotate_transformations_based_on_orientation(
        movement,
        game_obj.piece_info[piece_name][:orientation]
      )

    game_obj = put_in(game_obj.piece_behavior[behavior].movement, movement)
    movement = game_obj.piece_behavior[behavior][:movement]

    moves =
      Enum.reduce(movement, [], fn branch, acc ->
        new_moves =
          move_along_branch_and_record_moves(:ok, piece_name, piece_position, game_obj, branch, [])

        [new_moves | acc]
      end)

    moves
    |> List.flatten()
    |> Enum.uniq()
  end

  # a path is the connection of multiple branches -> path: branch -- branch --- branch
  def move_along_branch_and_record_moves(:ok, piece_name, piece_position, game_obj, branch, moves) when branch.steps > 0 do
    branch = Map.put(branch, :steps, decrement_steps(branch.steps))
    piece_position = apply_transformation(piece_position, branch.transformation)

    {continue_path, record_move, _no_capture} =
      {true, true, true}
      |> check_in_bounds(piece_position, game_obj)
      |> check_status_of_space(piece_name, piece_position, game_obj, branch)
      |> check_recording_opts(branch)
      |> check_if_final_move_in_path(branch)

    moves = maybe_record_move(record_move, piece_position, moves)

    continue_path = if continue_path do :ok else :stop end
    move_along_branch_and_record_moves(continue_path, piece_name, piece_position, game_obj, branch, moves)
  end

  def move_along_branch_and_record_moves(:ok, piece_name, piece_position, game_obj, branch, moves) do
      if length(branch.branches) > 0 do
      Enum.reduce(branch.branches, moves, fn child_branch, acc ->
        new_moves =
          move_along_branch_and_record_moves(:ok, piece_name, piece_position, game_obj, child_branch, moves)
        [new_moves | acc]
      end)
    else
      move_along_branch_and_record_moves(:stop, piece_name, piece_position, game_obj, branch, moves)
    end
  end

  def move_along_branch_and_record_moves(:stop, _piece_name, _piece_position, _game_obj, _branch, moves) do
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

  defp check_in_bounds({continue_path, record_move, no_capture}, piece_position, game_obj) do
    if !Map.has_key?(game_obj.board, piece_position) do
      {false, false, no_capture}
    else
      {continue_path, record_move, no_capture}
    end
  end

  def check_status_of_space(
        {continue_path, record_move, no_capture},
        piece_name,
        piece_position,
        game_obj,
        branch
      ) do
    space = game_obj.board[piece_position]
    if space === :empty or space === nil do
      {continue_path, record_move, no_capture}
    else
      {continue_path, record_move, no_capture}
      |> check_movement_only(branch)
      |> check_jump(branch)
      |> check_if_friendly(piece_name, space, game_obj)
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
         game_obj
       ) do
    if game_obj.piece_info[space].owner === game_obj.piece_info[piece_name].owner do
      {continue_path, false, no_capture}
    else
      {continue_path, record_move, false}
    end
  end

  def check_recording_opts({continue_path, record_move, no_capture}, movement_map) do
    opts = movement_map.opts

    {continue_path, record_move, no_capture}
    |> check_dont_record(opts)
    |> check_endpoint_only(opts, movement_map)
    |> check_resolution(opts, movement_map)
    |> check_capture_only(opts)
  end

  defp check_dont_record({continue_path, record_move, no_capture}, opts) do
    if Keyword.has_key?(opts, :dont_record) do
      {continue_path, false, no_capture}
    else
      {continue_path, record_move, no_capture}
    end
  end

  defp check_endpoint_only({continue_path, record_move, no_capture}, opts, movement_map) do
    if Keyword.has_key?(opts, :endpoint_only) and movement_map.steps != 0 do
      {continue_path, false, no_capture}
    else
      {continue_path, record_move, no_capture}
    end
  end

  defp check_resolution({continue_path, record_move, no_capture}, opts, movement_map) do
    if Keyword.has_key?(opts, :resolution) and
         rem(movement_map.steps, opts[:resolution]) != 0 do
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

  ### MOVEMENT END

  # returns a list of tuples (transformations), with home many times to apply them

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

  # custom transformation -> :px, :nx, :py, :ny, :pz, :nz
  # test {:ny, :px, :pz} should be the same as rotate_90_degrees_counterclockwise_along_z_axis
  def transform_coordinates_by_generic_transformation(coordinates, generic_transformation) do
    coordinates = Tuple.to_list(coordinates)
    generic_transformation = Tuple.to_list(generic_transformation)
    [x, y, z] = coordinates
    px_pos = find_index(generic_transformation, :px)
    nx_pos = find_index(generic_transformation, :nx)
    py_pos = find_index(generic_transformation, :py)
    ny_pos = find_index(generic_transformation, :ny)
    pz_pos = find_index(generic_transformation, :pz)
    nz_pos = find_index(generic_transformation, :nz)

    {:empty, :empty, :empty}
    |> apply_position(px_pos, x)
    |> apply_position(nx_pos, -x)
    |> apply_position(py_pos, y)
    |> apply_position(ny_pos, -y)
    |> apply_position(pz_pos, z)
    |> apply_position(nz_pos, -z)
  end

  defp apply_position(coords, nil, _pos), do: coords

  defp apply_position(coords, val, pos) do
    put_elem(coords, val, pos)
  end

  defp find_index(transformation, pos) do
    transformation
    |> Enum.find_index(fn x -> x === pos end)
  end

  def rotate_transformations_based_on_orientation(movement, orientation) do
    generic_transformation = orientation_to_generic_transformation(orientation)
    update_transformation_crawler(movement, generic_transformation)
  end

  defp update_transformation_crawler([current_obj | remaining_objs], generic_transformation) do
    new_transformation =
      transform_coordinates_by_generic_transformation(
        current_obj.transformation,
        generic_transformation
      )

    updated_head = Map.put(current_obj, :transformation, new_transformation)

    updated_head =
      Map.put(
        updated_head,
        :branches,
        update_transformation_crawler(updated_head.branches, generic_transformation)
      )

    [updated_head | update_transformation_crawler(remaining_objs, generic_transformation)]
  end

  defp update_transformation_crawler([], _generic_transformation) do
    []
  end

  ## player 1 default is up_direction {0, 0, 1} facing_direction {0, 1, 0}
  ## player 2 default is up_direction {0, 0, -1} facing_direction {0, -1, 0}
  defp orientation_to_generic_transformation(orientation) do
    case orientation do
      %{up: {0, 0, 1}, facing: {0, 1, 0}} -> {:px, :py, :pz}
      %{up: {0, 0, 1}, facing: {1, 0, 0}} -> {:py, :nx, :pz}
      %{up: {0, 0, 1}, facing: {0, -1, 0}} -> {:nx, :ny, :pz}
      %{up: {0, 0, 1}, facing: {-1, 0, 0}} -> {:ny, :px, :pz}
      %{up: {0, 0, -1}, facing: {0, 1, 0}} -> {:nx, :py, :nz}
      %{up: {0, 0, -1}, facing: {1, 0, 0}} -> {:py, :px, :nz}
      %{up: {0, 0, -1}, facing: {0, -1, 0}} -> {:px, :ny, :nz}
      %{up: {0, 0, -1}, facing: {-1, 0, 0}} -> {:ny, :nx, :nz}
      %{up: {0, 1, 0}, facing: {0, 0, -1}} -> {:px, :pz, :ny}
      %{up: {0, 1, 0}, facing: {1, 0, 0}} -> {:py, :pz, :px}
      %{up: {0, 1, 0}, facing: {0, 0, 1}} -> {:nx, :pz, :py}
      %{up: {0, 1, 0}, facing: {-1, 0, 0}} -> {:ny, :pz, :nx}
      %{up: {0, -1, 0}, facing: {0, 0, -1}} -> {:nx, :nz, :ny}
      %{up: {0, -1, 0}, facing: {1, 0, 0}} -> {:py, :nz, :nx}
      %{up: {0, -1, 0}, facing: {0, 0, 1}} -> {:px, :nz, :py}
      %{up: {0, -1, 0}, facing: {-1, 0, 0}} -> {:ny, :nz, :px}
      %{up: {1, 0, 0}, facing: {0, 1, 0}} -> {:pz, :py, :nx}
      %{up: {1, 0, 0}, facing: {0, 0, 1}} -> {:pz, :px, :py}
      %{up: {1, 0, 0}, facing: {0, -1, 0}} -> {:pz, :ny, :px}
      %{up: {1, 0, 0}, facing: {0, 0, -1}} -> {:pz, :nx, :ny}
      %{up: {-1, 0, 0}, facing: {0, 1, 0}} -> {:nz, :py, :px}
      %{up: {-1, 0, 0}, facing: {0, 0, 1}} -> {:nz, :nx, :py}
      %{up: {-1, 0, 0}, facing: {0, -1, 0}} -> {:nz, :ny, :nx}
      %{up: {-1, 0, 0}, facing: {0, 0, -1}} -> {:nz, :px, :ny}
    end
  end
end
