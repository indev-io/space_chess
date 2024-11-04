defmodule SpaceChess.GameOrganization.Lobby do
  use Ecto.Schema

  schema "lobby" do
    field :message, :string
    field :game_url, :string
    field :players_neede, :integer
  end
end
