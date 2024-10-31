defmodule SpaceChess.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      SpaceChessWeb.Telemetry,
      SpaceChess.Repo,
      {DNSCluster, query: Application.get_env(:space_chess, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: SpaceChess.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: SpaceChess.Finch},
      # Start a worker by calling: SpaceChess.Worker.start_link(arg)
      # {SpaceChess.Worker, arg},
      # Start to serve requests, typically the last entry
      SpaceChessWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: SpaceChess.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    SpaceChessWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
