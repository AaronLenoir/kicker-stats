defmodule GameStatsTest do
  use ExUnit.Case
  doctest GameStats

  test "collect_from_csv_stream finds single game" do
    stats =
      GameStats.Test.Helper.get_stream_from_string(
        "13/02/2023;playerA;playerB;10;0;playerC;playerD"
      )
      |> GameStats.collect_from_csv_stream()
      |> Enum.find(fn x -> x.year == 2023 end)

    assert stats.game_stats.game_count == 1
  end

  test "collect_from_csv_stream finds two games" do
    stats =
      GameStats.Test.Helper.get_stream_from_string(
        "13/02/2023;playerA;playerB;10;0;playerC;player\r\n14/02/2023;playerA;playerB;10;0;playerC;player\r\n"
      )
      |> GameStats.collect_from_csv_stream()
      |> Enum.find(fn x -> x.year == 2023 end)

    assert stats.game_stats.game_count == 2
  end

  test "parse_game with invalid game" do
    game = GameStats.parse_game("")

    assert is_nil(game)
  end

  test "parse_game with invalid game score returns nil" do
    game = GameStats.parse_game("13/02/2023;playerA;playerB;a;b;playerC;player")

    assert is_nil(game)
  end

  test "collect_from_csv_stream ignores invalid game" do
    {:ok, data_stream} =
      "13/02/2023;playerA;playerB;10;0;playerC;player\r\n14/02/2023;playerA;playerB;xx;yy;playerC;player\r\n"
      |> StringIO.open()

    stats =
      data_stream
      |> IO.binstream(:line)
      |> GameStats.collect_from_csv_stream()
      |> Enum.find(fn x -> x.year == 2023 end)

    assert stats.game_stats.game_count == 1
  end

  test "rating for winning team should be 416 after one game" do
    stats =
      GameStats.Test.Helper.get_stream_from_string(
        "13/02/2023;playerA;playerB;10;0;playerC;playerD"
      )
      |> GameStats.collect_from_csv_stream()
      |> Enum.find(fn x -> x.year == 2023 end)

    assert stats.player_stats.rating_by_player["playerA"] == 400 + 16
    assert stats.player_stats.rating_by_player["playerB"] == 400 + 16
  end

  test "rating for losing team should be 416 after one game" do
    stats =
      GameStats.Test.Helper.get_stream_from_string(
        "13/02/2023;playerA;playerB;10;0;playerC;playerD"
      )
      |> GameStats.collect_from_csv_stream()
      |> Enum.find(fn x -> x.year == 2023 end)

    assert stats.player_stats.rating_by_player["playerC"] == 400 - 16
    assert stats.player_stats.rating_by_player["playerD"] == 400 - 16
  end

  test "stats should be grouped per year" do
    stats =
      GameStats.Test.Helper.get_stream_from_string(
        "13/02/2022;playerA;playerB;10;0;playerC;playerD\r\n13/02/2023;playerA;playerB;10;0;playerC;playerD"
      )
      |> GameStats.collect_from_csv_stream()

    stats_2022 = Enum.find(stats, fn x -> x.year == 2022 end)
    stats_2023 = Enum.find(stats, fn x -> x.year == 2023 end)

    assert stats_2022.game_stats.game_count == 1
    assert stats_2023.game_stats.game_count == 1
  end

  test "stats for year nil should include all games" do
    stats =
      GameStats.Test.Helper.get_stream_from_string(
        "13/02/2022;playerA;playerB;10;0;playerC;playerD\r\n13/02/2023;playerA;playerB;10;0;playerC;playerD"
      )
      |> GameStats.collect_from_csv_stream()
      |> Enum.find(fn x -> is_nil(x.year) end)

    assert stats.game_stats.game_count == 2
  end

  @tag perf: true
  @tag timeout: :infinity
  test "performance: processing large file is OK" do
    stats =
      File.stream!("test/assets/lots_of_games.csv")
      |> GameStats.collect_from_csv_stream()
      |> Enum.find(fn x -> x.year == 2023 end)

    assert stats.game_stats.game_count == 11_059_200
  end
end
