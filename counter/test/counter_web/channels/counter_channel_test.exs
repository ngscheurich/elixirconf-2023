defmodule Counter.CounterChannelTest do
  use ExUnit.Case, async: true
  import Phoenix.ChannelTest

  @endpoint CounterWeb.Endpoint

  setup do
    {:ok, reply, socket} =
      CounterWeb.UserSocket
      |> socket(nil, %{})
      |> subscribe_and_join(CounterWeb.CounterChannel, "counter")

    %{reply: reply, socket: socket}
  end

  test "replies with count of 0 on join", %{reply: reply} do
    assert reply == %{count: 0}
  end

  test "replies with new count on count:inc", %{socket: socket} do
    ref = push(socket, "count:inc", %{})
    assert_reply ref, :ok, %{count: 1}

    ref = push(socket, "count:inc", %{})
    assert_reply ref, :ok, %{count: 2}
  end
end
