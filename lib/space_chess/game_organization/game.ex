defmodule SpaceChess.GameOrganization.Game do
  alias SpaceChess.GameOrganization.{GameBoard, GamePiece, GameType}
  import Ecto.Query
  use Ecto.Schema
  import Ecto.Changeset

  schema "games" do
    field :in_progress, :boolean
    field :num_players, :integer
    field :outcome, :map
    field :game_url, :string
    has_many :winners, SpaceChess.Accounts.User
    has_many :players, SpaceChess.Accounts.User
    has_many :game_boards, GameBoard
    has_one :game_type, GameType
  end
end
