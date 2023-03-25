defmodule GameStats.Collectors.GameTest do
  use ExUnit.Case
  doctest GameStats.Collectors.Game

  test "any game that is not nil is counted" do
    current_stats = GameStats.Collectors.Game.collect([])
    latest_stats = GameStats.Collectors.Game.collect([], current_stats)

    assert latest_stats.game_count == 2
  end

  test "collect with no argument initialised game_stats" do
    %{game_count: game_count} = GameStats.Collectors.Game.initialize()

    assert game_count == 0
  end
end
