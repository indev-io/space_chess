defmodule SpaceChess.Accounts.Followers do
  alias SpaceChess.Accounts.User
  use Ecto.Schema

  schema "followers" do
    field :follower_id, :integer
    has_one :user, User
  end
end
