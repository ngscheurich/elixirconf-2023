defmodule CounterWeb.CounterLive do
  use CounterWeb, :live_view

  alias Counter.Repo
  alias Phoenix.PubSub

  @impl true
  def mount(_params, %{"_csrf_token" => token}, socket) do
    count =
      case Repo.get_count(token) do
        {:ok, count} -> count
        :error -> 0
      end

    socket =
      socket
      |> assign(:token, token)
      |> assign(:count, count)
      |> assign(:wrapper_class, wrapper_class())

    PubSub.subscribe(Counter.PubSub, "counters:#{token}")

    {:ok, socket}
  end

  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign(:count, 0)
      |> assign(:wrapper_class, wrapper_class())

    {:ok, socket}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div class={@wrapper_class}>
      <div>
        <button phx-click="inc" class="big-button w-48 h-48 rounded-full bg-slides-medium block">
          <span class="text-6xl">
            <%= @count %>
          </span>
        </button>
      </div>
    </div>
    """
  end

  @impl true
  def handle_event("inc", _params, %{assigns: %{token: token}} = socket) do
    {:ok, count} = Repo.increment(token)
    {:noreply, assign(socket, :count, count)}
  end

  @impl true
  def handle_info({:new_count, count}, socket) do
    {:noreply, assign(socket, :count, count)}
  end

  defp wrapper_class do
    ~w[
      bg-cover
      bg-slides-dark
      flex
      flex
      flex-col
      font-bold
      h-screen
      items-center
      items-center
      justify-center
      text-slides-light
    ] ++ ["bg-[url('/images/background.jpg')]"]
  end
end
