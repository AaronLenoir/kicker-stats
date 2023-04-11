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

    assert %{"Player A - Player B" => 1} = player_stats.highest_ranking_team
  end

  test "the highest ranking team for Player A is the team that won 3 times" do
    stats = GameStatsCollector.collect_from_games([
      Game.parse("01/01/2023;Player A;Player B;10;0;Player C;Player D"),
      Game.parse("01/01/2023;Player A;Player B;00;10;Player C;Player D"),
      Game.parse("01/01/2023;Player X;Player B;0;10;Player A;Player D"),
      Game.parse("01/01/2023;Player X;Player B;0;10;Player A;Player D"),
      Game.parse("01/01/2023;Player X;Player B;0;10;Player A;Player D")
    ])
    |> Enum.find(fn stats -> stats.year == 2023 end)

    assert %{"Player A - Player D" => 1} = stats.player["Player A"].highest_ranking_team
    assert %{"Player C - Player D" => 2} = stats.player["Player C"].highest_ranking_team
  end

  test "average team rating should be 416 (after one won game)" do
    stats = GameStatsCollector.collect_from_games([
      Game.parse("01/01/2023;Player A;Player B;10;0;Player C;Player D")
    ])
    |> Enum.find(fn stats -> stats.year == 2023 end)

    assert stats.player["Player A"].average_team_rating == 416
  end

  test "average team rating should be 431 (after two won games)" do
    stats = GameStatsCollector.collect_from_games([
      Game.parse("01/01/2023;Player A;Player B;10;0;Player C;Player D"),
      Game.parse("01/01/2023;Player A;Player B;10;0;Player C;Player D")
    ])
    |> Enum.find(fn stats -> stats.year == 2023 end)

    assert stats.player["Player A"].average_team_rating == 431
  end

  test "average team rating should be 416 (after two won games but with different teams)" do
    stats = GameStatsCollector.collect_from_games([
      Game.parse("01/01/2023;Player A;Player B;10;0;Player C;Player D"),
      Game.parse("01/01/2023;Player A;Player X;10;0;Player Y;Player Z")
    ])
    |> Enum.find(fn stats -> stats.year == 2023 end)

    assert stats.player["Player A"].average_team_rating == 416
  end

  test "average team rating should be 416 (after one won games but with between unrelated games)" do
    stats = GameStatsCollector.collect_from_games([
      Game.parse("01/01/2023;Player A;Player B;10;0;Player C;Player D"),
      Game.parse("01/01/2023;Player E;Player F;0;10;Player G;Player H"),
      Game.parse("01/01/2023;Player A;Player Z;10;0;Player B;Player C")
    ])
    |> Enum.find(fn stats -> stats.year == 2023 end)

    assert stats.player["Player G"].average_team_rating == 416
  end
end
