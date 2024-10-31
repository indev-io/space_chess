defmodule SpaceChess.Repo.Migrations.AddMessagesTable do
  use Ecto.Migration

  def change do
    create table(:messages) do
      add :message, :string
      add :sender_name, :string
      add :sender_id, :integer
      add :conversation_id, references(:conversations)
      timestamps(type: :utc_datetime)
    end
  end
end
