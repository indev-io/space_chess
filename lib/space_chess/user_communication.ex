defmodule SpaceChess.Messages do
  @moduledoc """
  The Messages context
  """
  alias SpaceChess.Repo

  alias SpaceChess.UserCommunication.{Conversation, Message}

  def create_conversation do
    Repo.insert(%Conversation{})
  end

  def create_message(attrs) do
    %Message{}
    |> Message.changeset(attrs)
    |> Repo.insert()
  end
end
