defmodule SpaceChess.AI do
alias SpaceChess.GameEngine

def maxi_max(game_obj, player, depth) do
  Task.Supervisor.start_link(name: MaxiMaxSupervisor)
  moves = GameEngine.get_all_moves_of_all_pieces(game_obj)
  moves = moves
    |> Enum.reject(fn {key, _value} -> game_obj.piece_info[key].owner !== player end)
    |> Enum.into(%{})


  Task.Supervisor.async_stream_nolink(MaxiMaxSupervisor, moves,
    fn {piece_name, moves} ->
      Enum.reduce(moves, [], fn move, acc ->
        board = GameEngine.make_move(piece_name, move, game_obj.board)
        game_obj = game_obj
        |> Map.put(:board, board)
        |> GameEngine.next_turn()
        args = {game_obj, player, {piece_name, move}, depth - 1}
        [future_path_crawler(args) | acc]
      end)
    end
  )
  |> Enum.to_list()

  end

  def future_path_crawler(args) do
    {game_obj, og_player, og_move, depth} = args
    if depth > 0 do
      moves = GameEngine.get_all_moves_of_all_pieces(game_obj)
      moves = moves
        |> Enum.reject(fn {key, _value} -> game_obj.piece_info[key].owner !== og_player end)
        |> Enum.into(%{})
      Task.Supervisor.async_stream_nolink(MaxiMaxSupervisor, moves,
      fn {piece_name, moves} ->
        Enum.reduce(moves, [], fn move, acc ->
          board = GameEngine.make_move(piece_name, move, game_obj.board)
          game_obj = game_obj
          |> Map.put(:board, board)
          |> GameEngine.next_turn()
          args = {game_obj, og_player, og_move, depth - 1}
          [future_path_crawler(args) | acc]
        end)
      end
    )
    |> Stream.run()
    # |> Enum.to_list()
    else
     {og_move, GameEngine.evaluate_board(game_obj, og_player)}
    end



  end


end
