defmodule CounterWeb.CounterChannel do
  use Phoenix.Channel
  alias Counter.Repo

  @impl true
  def join("counter", _message, socket) do
    {:ok, %{count: 0}, socket}
  end

  @impl true
  def handle_in("count:inc", _payload, socket) do
    {:ok, count} = Repo.increment(self())
    {:reply, {:ok, %{count: count}}, socket}
  end
end
