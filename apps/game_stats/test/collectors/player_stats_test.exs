defmodule GameStats.Collectors.PlayerStatsTest do
  use ExUnit.Case

  import GameStats.Collectors.PlayerStats
  alias GameStats.Model.Game

  test "new creates player stats struct with player name" do
    assert %{name: "Aaron", games_played: _} = new("Aaron")
  end

  test "collect counts 1 played game for each player after processing 1 game" do
    stats = collect(%{}, Game.parse("01/01/2023;Player A;Player B;10;0;Player C;Player D"))

    assert stats["Player A"].games_played == 1
    assert stats["Player B"].games_played == 1
    assert stats["Player C"].games_played == 1
    assert stats["Player D"].games_played == 1
  end

  test "collect counts 2 played game for each player after processing 2 games" do
    stats =
      collect(%{}, Game.parse("01/01/2023;Player A;Player B;10;0;Player C;Player D"))
      |> collect(Game.parse("01/01/2023;Player A;Player B;10;0;Player C;Player D"))

    assert stats["Player A"].games_played == 2
    assert stats["Player B"].games_played == 2
    assert stats["Player C"].games_played == 2
    assert stats["Player D"].games_played == 2
  end

  test "collect counts 1 game won for each winning player" do
    stats = collect(%{}, Game.parse("01/01/2023;Player A;Player B;10;0;Player C;Player D"))

    assert stats["Player A"].games_won == 1
    assert stats["Player B"].games_won == 1
  end

  test "collect counts 0 games won for each losing player" do
    stats = collect(%{}, Game.parse("01/01/2023;Player A;Player B;10;0;Player C;Player D"))

    assert stats["Player C"].games_won == 0
    assert stats["Player D"].games_won == 0
  end
end
