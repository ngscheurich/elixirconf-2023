defmodule Counter.WatcherChannelTest do
  use ExUnit.Case, async: true
  import Phoenix.ChannelTest

  @endpoint CounterWeb.Endpoint

  setup do
    Counter.Repo.increment(self())
    Counter.Repo.increment(self())

    {:ok, reply, socket} =
      CounterWeb.UserSocket
      |> socket(nil, %{})
      |> subscribe_and_join(CounterWeb.WatcherChannel, "watcher")

    %{reply: reply, socket: socket}
  end

  test "replies with repo average on join", %{reply: reply} do
    assert reply == %{average: 1}
  end

  test "broadcasts to watchers on new_average" do
    Counter.PubSub.broadcast_new_average!(10)
    assert_broadcast "new_average", %{average: 10}
  end
end
