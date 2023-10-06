defmodule CounterWeb.DebugLive do
  use CounterWeb, :live_view

  alias Counter.Repo
  alias Phoenix.PubSub

  @impl true
  def mount(_params, _session, socket) do
    PubSub.subscribe(Counter.PubSub, "watchers")
    socket = assign(socket, Repo.__info__())
    {:ok, socket}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div class="flex gap-8 m-auto p-8 items-top">
      <div class="border p-8 min-w-[200px]">
        <dl class="text-center mb-6">
          <dt class="mb-4">Average</dt>
          <dd class="text-7xl font-bold"><%= @average %></dd>
        </dl>
        <.button phx-click="recalculate-average" class="w-full">
          <.icon name="hero-arrow-path" class="mr-1" />
          Recalculate
        </.button>
      </div>
      <div class="w-full">
        <table class="table-auto text-left border w-full">
          <thead>
            <tr>
              <th class="p-2">Token</th>
              <th class="p-2">Count</th>
              <th class="p-2">Action</th>
            </tr>
          </thead>
          <tbody>
            <tr :for={{token, count} <- @counts}>
              <td class="p-2 border"><%= token %></td>
              <td class="p-2 border"><%= count %></td>
              <td class="p-2 border w-[120px]">
                <.button phx-click="clear" phx-value-token={token} class="w-full">
                  <.icon name="hero-x-circle" class="mr-1" />
                  Clear
                </.button>
              </td>
            </tr>
          </tbody>
        </table>
      </div>
    </div>
    """
  end

  @impl true
  def handle_event("clear", %{"token" => token}, socket) do
    Repo.clear(token)
    {:noreply, socket}
  end

  def handle_event("recalculate-average", _params, socket) do
    Repo.recalculate_average()
    {:noreply, socket}
  end

  @impl true
  def handle_info({:new_counts, counts}, socket) do
    {:noreply, assign(socket, :counts, counts)}
  end

  @impl true
  def handle_info({:new_average, average}, socket) do
    {:noreply, assign(socket, :average, average)}
  end
end
