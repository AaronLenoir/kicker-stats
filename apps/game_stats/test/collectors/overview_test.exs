defmodule GameStats.Collectors.OverviewTest do
  use ExUnit.Case

  import GameStats.Collectors.Ratings
  alias GameStats.Collectors.Collector
  alias GameStats.Model.Game
  alias GameStats.Model.Team
  alias GameStats.Model.TeamStats
  alias GameStats.Model.PlayerStats
  alias GameStats.Model.Stats

  test "Three teams are ranked according to the wins (3, 1 and 0 wins)" do
    stats = GameStatsCollector.collect_from_games([
      Game.parse("01/01/2023;Player A;Player B;0;10;Player C;Player D"),
      Game.parse("01/01/2023;Player A;Player B;0;10;Player C;Player D"),
      Game.parse("01/01/2023;Player A;Player B;0;10;Player C;Player D"),
      Game.parse("01/01/2023;Player X;Player B;10;0;Player C;Player D")
    ])
    |> Enum.find(fn stats -> stats.year == 2023 end)

    [first, second, third] = stats.overview.team_ranking

    assert Map.has_key?(first, "Player C - Player D")
    assert Map.has_key?(second, "Player X - Player B")
    assert Map.has_key?(third, "Player A - Player B")
  end

  test "the highest ranking player the one that won all the games (Player C)" do
    stats = GameStatsCollector.collect_from_games([
      Game.parse("01/01/2023;Player A;Player B;0;10;Player C;Player D"),
      Game.parse("01/01/2023;Player A;Player B;0;10;Player C;Player X"),
      Game.parse("01/01/2023;Player A;Player B;0;10;Player C;Player Y"),
      Game.parse("01/01/2023;Player X;Player B;0;10;Player C;Player D")
    ])
    |> Enum.find(fn stats -> stats.year == 2023 end)

    [first | _] = stats.overview.player_ranking

    assert Map.has_key?(first, "Player C")
  end
end
