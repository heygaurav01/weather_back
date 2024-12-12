defmodule WeatherBack.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      WeatherBackWeb.Telemetry,
      WeatherBack.Repo,
      {DNSCluster, query: Application.get_env(:weather_back, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: WeatherBack.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: WeatherBack.Finch},
      # Start a worker by calling: WeatherBack.Worker.start_link(arg)
      # {WeatherBack.Worker, arg},
      # Start to serve requests, typically the last entry
      WeatherBackWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: WeatherBack.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    WeatherBackWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
