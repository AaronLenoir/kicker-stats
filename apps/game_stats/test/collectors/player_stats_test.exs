defmodule GameStats.Collectors.PlayerStatsTest do
  use ExUnit.Case

  import GameStats.Collectors.PlayerStats

  test "new creates player stats struct with player name" do
    assert %{name: "Aaron", games_played: _} = new("Aaron")
  end

  test "collect counts 1 played game for each player after processing 1 game" do
    stats = collect(%{}, GameStats.parse_game("01/01/2023;Player A;Player B;10;0;Player C;Player D"))

    assert stats["Player A"].games_played == 1
    assert stats["Player B"].games_played == 1
    assert stats["Player C"].games_played == 1
    assert stats["Player D"].games_played == 1
  end

end
