defmodule SpaceChess.Repo do
  use Ecto.Repo,
    otp_app: :space_chess,
    adapter: Ecto.Adapters.Postgres
end
