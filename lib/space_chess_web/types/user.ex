defmodule SpaceChessWeb.Types.User do
  use Absinthe.Schema.Notation

  object :user do
    field :id, non_null(:id)
    field :email, non_null(:string)
    field :hashed_password, non_null(:string)
    field :confirmed_at, non_null(:string)
  end
end
