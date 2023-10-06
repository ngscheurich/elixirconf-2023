defmodule Counter.RepoTest do
  use ExUnit.Case, async: true

  alias Counter.Repo

  test "incremenets, averages, and clears counts" do
    pid = self()

    assert Repo.get_count(pid) == :error

    assert Repo.increment(pid) == {:ok, 1}
    assert Repo.get_count(pid) == {:ok, 1}

    Repo.increment(pid)
    Repo.increment(pid)

    assert Repo.get_count(pid) == {:ok, 3}
    assert Repo.get_average() == 3

    spawn(fn -> :ok end)

    for _ <- 0..2 do
      fn -> :ok end
      |> spawn()
      |> Repo.increment()
    end

    assert Repo.get_average() == 2

    Repo.clear(pid)

    assert Repo.get_count(pid) == :error
    assert Repo.get_average() == 1
  end
end
