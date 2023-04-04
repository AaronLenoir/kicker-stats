defmodule GameStats.Collectors.RatingsTest do
  use ExUnit.Case

  import GameStats.Collectors.Ratings
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
end
