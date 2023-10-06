defmodule CounterWeb.WatcherChannel do
  use Phoenix.Channel

  alias Counter.Repo
  alias Phoenix.PubSub

  @impl true
  def join("watcher", _message, socket) do
    PubSub.subscribe(Counter.PubSub, "watchers")
    {:ok, %{average: Repo.get_average()}, socket}
  end

  @impl true
  def handle_info({:new_average, average}, socket) do
    broadcast!(socket, "new_average", %{average: average})
    {:noreply, socket}
  end
end
