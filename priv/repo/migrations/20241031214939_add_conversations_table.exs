defmodule SpaceChess.Repo.Migrations.AddConversationsTable do
  use Ecto.Migration

  def change do
    create table(:conversations) do
      add :active, :boolean, null: false, default: true
      timestamps(type: :utc_datetime)
    end
  end
end
