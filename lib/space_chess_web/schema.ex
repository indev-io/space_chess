defmodule SpaceChessWeb.Schema do
  use Absinthe.Schema
  import_types(SpaceChessWeb.Types.User)
  import_types(SpaceChessWeb.Schema.Queries.User)

  query do
    import_fields(:user_queries)
  end
end
