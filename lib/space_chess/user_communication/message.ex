defmodule SpaceChess.UserCommunication.Message do
  alias SpaceChess.UserCommunication.Message
  import Ecto.Query
  use Ecto.Schema
  import Ecto.Changeset

  schema "messages" do
    field :message, :string
    field :sender_name, :string
    field :sender_id, :integer
    belongs_to :conversation, SpaceChess.UserCommunication.Conversation

    timestamps(type: :utc_datetime)
  end

  @available_fields [:message, :sender_name, :sender_id]
  @max_chars 250
  @doc false
  def changeset(changeset, attrs) do
    changeset
    |> cast(attrs, @available_fields)
    |> validate_required(@available_fields)
    |> validate_length(:message, max: @max_chars)
  end

  def from(query \\ Message), do: from(query, as: :message)

  def join_messages(query) do
    from u in query, preload: :messages, join: p in assoc(u, :messages), as: :message
  end
end
