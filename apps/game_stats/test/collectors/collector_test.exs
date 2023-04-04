defmodule GameStats.Collectors.CollectorTest do
  use ExUnit.Case

  import GameStats.Collectors.Collector
  alias GameStats.Collectors.Counters
  alias GameStats.Collectors.Ratings
  alias GameStats.Model.Game
  alias GameStats.Model.Stats

  test "collect counts 1 game in total" do
    stats =
      Stats.new()
      |> collect(Game.parse("01/01/2023;Player A;Player B;10;0;Player C;Player D"), Counters)

    assert stats.game.games_played == 1
  end

  test "collect counts 1 game for each player" do
    stats =
      Stats.new()
      |> collect(Game.parse("01/01/2023;Player A;Player B;10;0;Player C;Player D"), Counters)

    assert stats.player["Player A"].games_played == 1
    assert stats.player["Player B"].games_played == 1
    assert stats.player["Player C"].games_played == 1
    assert stats.player["Player D"].games_played == 1
  end

  test "collect counts 1 won game for each winner" do
    stats =
      Stats.new()
      |> collect(Game.parse("01/01/2023;Player A;Player B;10;0;Player C;Player D"), Counters)

    assert stats.player["Player A"].games_won == 1
    assert stats.player["Player B"].games_won == 1
  end

  test "collect increases rating to 416 after win" do
    stats =
      Stats.new()
      |> collect(Game.parse("01/01/2023;Player A;Player B;10;0;Player C;Player D"), Ratings)

    assert stats.team["Player A - Player B"].rating == 416
  end
end
