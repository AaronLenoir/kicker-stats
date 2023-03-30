defmodule GameStatsTest do
  use ExUnit.Case
  doctest GameStats

  test "collect_from_csv_stream for one game finds two sets of stats" do
    stats =
      GameStats.Test.Helper.get_stream_from_string(
        "13/02/2023;playerA;playerB;10;0;playerC;playerD"
      )
      |> GameStats.collect_from_csv_stream()

    assert length(stats) == 2
  end

  test "collect_from_csv_stream for two games in different years finds three sets of stats" do
    stats =
      GameStats.Test.Helper.get_stream_from_string(
        "13/02/2022;playerA;playerB;10;0;playerC;playerD\r\n13/02/2023;playerA;playerB;10;0;playerC;playerD"
      )
      |> GameStats.collect_from_csv_stream()

    assert length(stats) == 3
  end
end
