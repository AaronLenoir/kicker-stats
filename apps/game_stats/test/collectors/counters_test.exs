defmodule GameStats.Collectors.CountersTest do
  use ExUnit.Case

  import GameStats.Collectors.Counters
  alias GameStats.Model.Game
  alias GameStats.Model.Team
  alias GameStats.Model.Stats
  alias GameStats.Model.TeamStats
  alias GameStats.Model.PlayerStats
  alias GameStats.Model.GameStats

  test "update counts 1 game in total" do
    stats =
      update(
        GameStats.new(),
        Stats.new(),
        Game.parse("01/01/2023;Player A;Player B;10;0;Player C;Player D")
      )

    assert stats.games_played == 1
  end

  test "update counts 1 game for a team" do
    stats =
      update(
        TeamStats.new("Player A - Player B"),
        Stats.new(),
        Game.parse("01/01/2023;Player A;Player B;10;0;Player C;Player D"),
        %Team{keeper: "Player A", striker: "Player B", score: 10}
      )

    assert stats.games_played == 1
  end

  test "update counts 1 won game for a team" do
    stats =
      update(
        TeamStats.new("Player A - Player B"),
        Stats.new(),
        Game.parse("01/01/2023;Player A;Player B;10;0;Player C;Player D"),
        %Team{keeper: "Player A", striker: "Player B", score: 10}
      )

    assert stats.games_won == 1
  end

  test "update counts 1 game for a player" do
    stats =
      update(
        PlayerStats.new("Player A"),
        Stats.new(),
        Game.parse("01/01/2023;Player A;Player B;10;0;Player C;Player D"),
        %Team{keeper: "Player A", striker: "Player B", score: 10},
        "Player A"
      )

    assert stats.games_played == 1
  end

  test "update counts 1 won game for a player" do
    stats =
      update(
        PlayerStats.new("Player A"),
        Stats.new(),
        Game.parse("01/01/2023;Player A;Player B;10;0;Player C;Player D"),
        %Team{keeper: "Player A", striker: "Player B", score: 10},
        "Player A"
      )

    assert stats.games_won == 1
  end

  test "update counts 1 streak for a winning player and a highest streak of 2 after 2 wins in a row" do
    stats =
      update(
        PlayerStats.new("Player A"),
        Stats.new(),
        Game.parse("01/01/2023;Player A;Player B;10;0;Player C;Player D"),
        %Team{keeper: "Player A", striker: "Player B", score: 10},
        "Player A"
      )
      |> update(
        Stats.new(),
        Game.parse("01/01/2023;Player A;Player B;10;0;Player C;Player D"),
        %Team{keeper: "Player A", striker: "Player B", score: 10},
        "Player A"
      )
    |> update(
      Stats.new(),
      Game.parse("01/01/2023;Player A;Player B;0;10;Player C;Player D"),
      %Team{keeper: "Player A", striker: "Player B", score: 10},
      "Player A"
    )
    |> update(
      Stats.new(),
      Game.parse("01/01/2023;Player A;Player B;10;0;Player C;Player D"),
      %Team{keeper: "Player A", striker: "Player B", score: 10},
      "Player A"
    )

    assert stats.streak == 1
    assert stats.longest_streak == 2
  end
end
