defmodule SpaceChessWeb.GameLive do
  use SpaceChessWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <div phx-update phx-hook="ThreeHook" id="threejs-container" phx-update="ignore"></div>
    <button>Scramble Board</button>
    """
  end
end
