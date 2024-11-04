defmodule SpaceChess.Accounts.UserFollowers do
  alias SpaceChess.Accounts.{User, Followers}
  use Ecto.Schema

  schema "user_followers" do
    has_one :user, User
    has_many :followers, Followers
  end
end
