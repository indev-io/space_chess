defmodule SpaceChessWeb.HomeLive do
  use SpaceChessWeb, :live_view

  def render(assigns) do
    ~H"""
    <.header>
      <div>Welcome Home</div>
    </.header>
    """
  end

  def mount(_params, _session, socket) do
    {:ok, socket}
  end
end
