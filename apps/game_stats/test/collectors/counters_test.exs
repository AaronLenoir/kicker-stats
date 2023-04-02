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
end
