defmodule SpaceChess.Messages do
  @moduledoc """
  The Messages context
  """
  import Ecto.Query
  alias SpaceChess.Repo

  alias SpaceChess.Messages.{Conversation, Message}

  def create_conversation() do
    Repo.insert(%Conversation{})
  end

  def create_message(attrs) do
    %Message{}
    |> Message.changeset(attrs)
    |> Repo.insert()
  end
end
