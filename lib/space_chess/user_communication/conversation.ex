defmodule SpaceChess.UserCommunication.Conversation do
  use Ecto.Schema
  alias SpaceChess.UserCommunication.Message

  schema "conversations" do
    field :active, :boolean, default: true
    has_many :messages, Message
    timestamps(type: :utc_datetime)
  end
end
