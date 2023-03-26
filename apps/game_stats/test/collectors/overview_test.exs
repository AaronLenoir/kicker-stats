defmodule GameStats.Collectors.OverviewTest do
  use ExUnit.Case
  doctest GameStats.Collectors.Overview

  test "ten games with the same players results in a ranking with 4 players (minimum of 10 games)" do
    stats =
      List.duplicate("13/02/2023;playerA;playerB;10;0;playerC;playerD", 10)
      |> Enum.reduce(fn x, acc -> "#{acc}\r\n#{x}" end)
      |> GameStats.Test.Helper.get_stream_from_string()
      |> GameStats.collect_from_csv_stream()
      |> Enum.find(fn x -> x.year == 2023 end)

    assert length(stats.overview.player_ranking) == 4
  end

  test "players with less than 10 games should not be in the ranking" do
    stats =
      [
        "13/02/2023;playerA;playerB;10;0;playerC;playerX"
        | List.duplicate("13/02/2023;playerA;playerB;10;0;playerC;playerD", 9)
      ]
      |> Enum.reduce(fn x, acc -> "#{acc}\r\n#{x}" end)
      |> GameStats.Test.Helper.get_stream_from_string()
      |> GameStats.collect_from_csv_stream()
      |> Enum.find(fn x -> x.year == 2023 end)

    assert length(stats.overview.player_ranking) == 3
  end

  test "player ranking should have highest ranking first" do
    stats =
      [
        "13/02/2023;playerA;playerB;10;0;playerC;playerD",
        "13/02/2023;playerA;playerX;10;0;playerY;playerZ",
        "13/02/2023;playerA;playerB;10;0;playerY;playerZ",
        "13/02/2023;playerA;playerC;10;0;playerD;playerB",
        "13/02/2023;playerA;playerX;10;0;playerY;playerZ",
        "13/02/2023;playerA;playerB;10;0;playerY;playerZ",
        "13/02/2023;playerA;playerC;10;0;playerD;playerB",
        "13/02/2023;playerA;playerX;10;0;playerY;playerZ",
        "13/02/2023;playerA;playerB;10;0;playerY;playerZ",
        "13/02/2023;playerA;playerC;10;0;playerD;playerB",
        "13/02/2023;playerA;playerX;10;0;playerY;playerZ",
        "13/02/2023;playerA;playerB;10;0;playerY;playerZ",
        "13/02/2023;playerA;playerC;10;0;playerD;playerB",
        "13/02/2023;playerA;playerX;10;0;playerY;playerZ",
        "13/02/2023;playerA;playerB;10;0;playerY;playerZ",
        "13/02/2023;playerA;playerC;10;0;playerD;playerB",
        "13/02/2023;playerA;playerX;10;0;playerY;playerZ",
        "13/02/2023;playerA;playerB;10;0;playerY;playerZ",
        "13/02/2023;playerA;playerC;10;0;playerD;playerB",
        "13/02/2023;playerA;playerX;10;0;playerY;playerZ",
        "13/02/2023;playerA;playerB;10;0;playerY;playerZ",
        "13/02/2023;playerA;playerC;10;0;playerD;playerB"
      ]
      |> Enum.reduce(fn x, acc -> "#{acc}\r\n#{x}" end)
      |> GameStats.Test.Helper.get_stream_from_string()
      |> GameStats.collect_from_csv_stream()
      |> Enum.find(fn x -> x.year == 2023 end)

    IO.inspect(stats.overview)

    maximum_rating =
      stats.overview.player_ranking
      |> Enum.max_by(fn x -> x.rating end)

    [first | _] = stats.overview.player_ranking
    assert maximum_rating.rating == first.rating
  end
end
