defmodule GameStats.Collectors.GameStatsTest do
  use ExUnit.Case

  test "new creates games stats struct with game_count set to 0" do
    assert %GameStats.Collectors.GameStats{games_played: 0} = GameStats.Collectors.GameStats.new()
  end

  test "collect with one game counts 1 game" do
    stats =
      GameStats.Collectors.GameStats.new()
      |> GameStats.Collectors.GameStats.collect(
        GameStats.Model.Game.parse("01/01/2023;Player A;Player B;10;0;Player C;Player D")
      )

    assert stats.games_played == 1
  end

  test "collect with two games counts 2 games" do
    stats =
      GameStats.Collectors.GameStats.new()
      |> GameStats.Collectors.GameStats.collect(
        GameStats.Model.Game.parse("01/01/2023;Player A;Player B;10;0;Player C;Player D")
      )
      |> GameStats.Collectors.GameStats.collect(
        GameStats.Model.Game.parse("02/01/2023;Player A;Player B;10;0;Player C;Player D")
      )

    assert stats.games_played == 2
  end
end
