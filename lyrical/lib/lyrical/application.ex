defmodule Lyrical.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      LyricalWeb.Telemetry,
      # Start the Ecto repository
      Lyrical.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: Lyrical.PubSub},
      # Start the Endpoint (http/https)
      LyricalWeb.Endpoint
      # Start a worker by calling: Lyrical.Worker.start_link(arg)
      # {Lyrical.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Lyrical.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    LyricalWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
