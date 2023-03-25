defmodule GameStats.Collectors.PlayerTest do
  use ExUnit.Case
  doctest GameStats.Collectors.Player

  test "collect with one game should count 1 game per player" do
    %{game_count_by_player: game_count} =
      GameStats.parse_game("01/01/2023;keeperA;strikerA;10;0;keeperB;strikerB")
      |> GameStats.Collectors.Player.collect()

    assert game_count["keeperA"] == 1
    assert game_count["strikerA"] == 1
    assert game_count["keeperB"] == 1
    assert game_count["strikerB"] == 1
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
        GameStats.Collectors.Player.initialize(),
        fn game, acc -> {game, GameStats.Collectors.Player.collect(game, acc)} end
      )

    assert stats.game_count_by_player["keeperA"] == 5
    assert stats.game_count_by_player["strikerA"] == 5
    assert stats.game_count_by_player["keeperB"] == 5
    assert stats.game_count_by_player["strikerB"] == 5
  end
end
