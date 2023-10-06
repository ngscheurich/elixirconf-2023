defmodule Counter.PubSub do
  alias Phoenix.PubSub

  @doc """
  Broadcasts new average to watchers.
  """
  def broadcast_new_average!(average) when is_number(average) do
    PubSub.broadcast!(Counter.PubSub, "watchers", {:new_average, average})
  end

  @doc """
  Broadcasts new counts to watchers.
  """
  def broadcast_new_counts!(counts) when is_map(counts) do
    PubSub.broadcast!(Counter.PubSub, "watchers", {:new_counts, counts})
  end

  @doc """
  Broadcasts new count to counter.
  """
  def broadcast_new_count!(token, count) when is_number(count) do
    PubSub.broadcast!(Counter.PubSub, "counters:#{token}", {:new_count, count})
  end
end
