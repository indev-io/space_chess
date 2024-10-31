defmodule SpaceChessWeb.GameLive do
  use SpaceChessWeb, :live_view

  def render(assigns) do
    ~H"""
    <.header>
      <div>Does this have any logging capabilities</div>
    </.header>
    """
  end

  def mount(_params, _session, socket) do
    {:ok, socket}
  end
end
