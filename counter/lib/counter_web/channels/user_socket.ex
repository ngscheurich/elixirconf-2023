defmodule CounterWeb.UserSocket do
  use Phoenix.Socket

  channel("counter", CounterWeb.CounterChannel)
  channel("watcher", CounterWeb.WatcherChannel)

  @impl true
  def connect(_params, socket) do
    {:ok, socket}
  end

  @impl true
  def id(_socket), do: nil
end
