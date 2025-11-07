defmodule Streamlet.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      StreamletWeb.Telemetry,
      Streamlet.Repo,
      {DNSCluster, query: Application.get_env(:streamlet, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Streamlet.PubSub},
      # Start a worker by calling: Streamlet.Worker.start_link(arg)
      # {Streamlet.Worker, arg},
      # Start to serve requests, typically the last entry
      StreamletWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Streamlet.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    StreamletWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
