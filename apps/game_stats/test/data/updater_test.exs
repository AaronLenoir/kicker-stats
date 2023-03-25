defmodule GameStats.Data.UpdaterTest do
  use ExUnit.Case
  doctest GameStats.Data.Updater

  setup_all do
    {:ok, %{cache: GameStats.Test.Helper.start_dummy_cache()}}
  end

  test "update scheduled work" do
    GameStats.Data.Updater.init(%{
      get: fn -> nil end,
      interval: 10,
      cache_name: :dummy_cache
    })

    assert_receive :work, 20
  end

  test "updater calls provided get_stream periodically when started" do
    stream = GameStats.Test.Helper.get_stream_from_string("")

    my_pid = self()

    GameStats.Data.Updater.start_link(%{
      get: fn ->
        send(my_pid, {:hello, "world"})
        stream
      end,
      interval: 10, cache_name: :dummy_cache
    })

    assert_receive {:hello, "world"}, 20
    assert_receive {:hello, "world"}, 60
  end
end
