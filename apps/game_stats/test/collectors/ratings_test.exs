defmodule GameStats.Collectors.RatingsTest do
  use ExUnit.Case

  import GameStats.Collectors.Ratings
  alias GameStats.Collectors.Collector
  alias GameStats.Model.Game
  alias GameStats.Model.Team
  alias GameStats.Model.TeamStats
  alias GameStats.Model.PlayerStats
  alias GameStats.Model.Stats

  test "collect updates rating to 400 + 16 for the winning team after one game" do
    stats =
      update(
        TeamStats.new("Player A - Player B"),
        Stats.new(),
        Game.parse("01/01/2023;Player A;Player B;10;0;Player C;Player D"),
        %Team{keeper: "Player A", striker: "Player B", score: 10}
      )

    assert stats.rating == 400 + 16
  end

  test "collect updates rating to 400 - 16 for the losing team after one game" do
    stats =
      update(
        TeamStats.new("Player A - Player B"),
        Stats.new(),
        Game.parse("01/01/2023;Player A;Player B;0;10;Player C;Player D"),
        %Team{keeper: "Player A", striker: "Player B", score: 0}
      )

    assert stats.rating == 400 - 16
  end

  test "collect updates highest rating to 400 + 16 for the winning team after one game" do
    stats =
      update(
        TeamStats.new("Player A - Player B"),
        Stats.new(),
        Game.parse("01/01/2023;Player A;Player B;10;0;Player C;Player D"),
        %Team{keeper: "Player A", striker: "Player B", score: 10}
      )

    assert stats.highest_rating == 400 + 16
  end

  test "collect updates highest rating to 400 + 16 for the winning player after one game" do
    stats =
      update(
        PlayerStats.new("Player A - Player B"),
        Stats.new(),
        Game.parse("01/01/2023;Player A;Player B;10;0;Player C;Player D"),
        %Team{keeper: "Player A", striker: "Player B", score: 10},
        "Player A"
      )

    assert stats.highest_rating == 400 + 16
  end

  test "summary updates highest ranking team to only team for player after 1 game" do
    stats = GameStatsCollector.collect_from_games([
      Game.parse("01/01/2023;Player A;Player B;10;0;Player C;Player D")
    ])
    |> Enum.find(fn stats -> stats.year == 2023 end)

    player_stats = stats.player["Player A"]

    IO.inspect(player_stats)

    assert player_stats.highest_ranking_team == %{team: "Player A - Player B", rating: 416}
  end

  test "the highest ranking team for Player A is the team that won 3 times" do
    stats = GameStatsCollector.collect_from_games([
      Game.parse("01/01/2023;Player A;Player B;10;0;Player C;Player D"),
      Game.parse("01/01/2023;Player A;Player B;00;10;Player C;Player D"),
      Game.parse("01/01/2023;Player B;Player B;0;10;Player A;Player D"),
      Game.parse("01/01/2023;Player B;Player B;0;10;Player A;Player D"),
      Game.parse("01/01/2023;Player B;Player B;0;10;Player A;Player D")
    ])
    |> Enum.find(fn stats -> stats.year == 2023 end)

    player_stats = stats.player["Player A"]

    IO.inspect(player_stats)

    assert player_stats.highest_ranking_team.team == "Player A - Player D"
  end
end
