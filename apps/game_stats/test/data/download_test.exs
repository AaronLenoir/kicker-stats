defmodule GameStats.Data.DownloadTest do
  use ExUnit.Case
  doctest GameStats.Data.Download

  @tag online: true
  test "csv is read from stream" do
    stats =
      GameStats.Data.Download.get_stream()
      |> GameStatsCollector.collect_from_csv_stream()

    assert length(stats) > 0
  end
end
