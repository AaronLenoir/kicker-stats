defmodule GameStats.Collectors.TeamTest do
  use ExUnit.Case
  doctest GameStats.Collectors.Team

  test "collect with one game should count 1 game per team" do
    %{game_count_by_team: game_count} =
      GameStats.parse_game("01/01/2023;keeperA;strikerA;10;0;keeperB;strikerB")
      |> GameStats.Collectors.Team.collect()

    assert game_count["keeperA - strikerA"] == 1
    assert game_count["keeperB - strikerB"] == 1
  end

  test "collect with one game should count 5 games for each player" do
    {_, stats} =
      [
        "01/01/2023;keeperA;strikerA;10;0;keeperB;strikerB",
        "01/01/2023;keeperA;strikerA;10;0;keeperB;strikerB",
        "01/01/2023;keeperA;strikerA;10;0;keeperB;strikerB",
        "01/01/2023;keeperA;strikerA;10;0;keeperB;strikerB",
        "01/01/2023;keeperA;strikerA;10;0;keeperB;strikerB"
      ]
      |> Enum.map(fn game -> GameStats.parse_game(game) end)
      |> Enum.map_reduce(
        GameStats.Collectors.Team.initialize(),
        fn game, acc -> {game, GameStats.Collectors.Team.collect(game, acc)} end
      )

    assert stats.game_count_by_team["keeperA - strikerA"] == 5
    assert stats.game_count_by_team["keeperB - strikerB"] == 5
  end
end
