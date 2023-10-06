defmodule Counter.Repo do
  use GenServer

  @doc """
  Starts the repo.
  """
  def start_link(opts) do
    opts = Keyword.put_new(opts, :name, __MODULE__)
    GenServer.start_link(__MODULE__, :ok, opts)
  end

  ## Client API

  @doc """
  Gets the count for the given `token`. 
  """
  def get_count(token) do
    GenServer.call(__MODULE__, {:get_count, token})
  end

  @doc """
  Increments the count for the given `token`.
  """
  def increment(token) do
    GenServer.call(__MODULE__, {:increment, token})
  end

  @doc """
  Clears the count for the given `token`.
  """
  def clear(token) do
    GenServer.cast(__MODULE__, {:clear, token})
  end

  @doc """
  Gets the average of all counts.
  """
  def get_average do
    GenServer.call(__MODULE__, :get_average)
  end

  @doc """
  Recalculates the average of all counts.
  """
  def recalculate_average do
    GenServer.cast(__MODULE__, :recalculate_average)
  end

  @doc false
  def __info__, do: GenServer.call(__MODULE__, :info)

  ## Server Callbacks

  @impl true
  def init(:ok) do
    {:ok, %{counts: %{}, average: 0}}
  end

  @impl true
  def handle_call({:get_count, token}, _from, state) do
    reply_with_count(state, token)
  end

  def handle_call(:get_average, _from, state) do
    {:reply, Map.fetch!(state, :average), state}
  end

  @impl true
  def handle_call({:increment, token}, _from, state) do
    state
    |> increment_count(token)
    |> calculate_average()
    |> reply_with_count(token)
  end

  def handle_call(:info, _from, state) do
    {:reply, state, state}
  end

  @impl true
  def handle_cast({:clear, token}, state) do
    state =
      state
      |> clear_count(token)
      |> calculate_average()

    Counter.PubSub.broadcast_new_counts!(state.counts)

    {:noreply, state}
  end

  def handle_cast(:recalculate_average, state) do
    state = calculate_average(state)
    {:noreply, state}
  end

  ## Helpers

  defp reply_with_count(%{counts: counts} = state, token) do
    {:reply, Map.fetch(counts, token), state}
  end

  defp increment_count(%{counts: counts} = state, token) do
    count = Map.get(counts, token) || 0
    state = put_in(state, [:counts, token], count + 1)

    Counter.PubSub.broadcast_new_counts!(state.counts)

    state
  end

  defp calculate_average(%{counts: counts} = state) when map_size(counts) == 0 do
    Counter.PubSub.broadcast_new_average!(0)
    Map.put(state, :average, 0)
  end

  defp calculate_average(%{counts: counts} = state) do
    values = Map.values(counts)
    average = round(Enum.sum(values) / Enum.count(values))

    Counter.PubSub.broadcast_new_average!(average)

    Map.put(state, :average, average)
  end

  defp clear_count(state, token) do
    {_, state} = pop_in(state, [:counts, token])

    Counter.PubSub.broadcast_new_count!(inspect(token), 0)

    state
  end
end
