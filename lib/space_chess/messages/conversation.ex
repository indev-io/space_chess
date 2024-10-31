defmodule SpaceChess.Messages.Conversation do
  use Ecto.Schema
  alias SpaceChess.Messages.Message

  schema "conversations" do
    field :active, :boolean, default: true
    has_many :messages, Message
    timestamps(type: :utc_datetime)
  end
end
