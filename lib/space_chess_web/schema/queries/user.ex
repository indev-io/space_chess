defmodule SpaceChessWeb.Schema.Queries.User do
  use Absinthe.Schema.Notation

  object :user_queries do
    field :users, list_of(:user) do
      resolve(&get_users/2)
    end

    def get_users(_params, _) do
      {:ok, SpaceChess.Accounts.get_all_users()}
    end
  end
end
