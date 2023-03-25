defmodule WebApiWeb.StatsJSON do
  require Logger

  def get_stream_from_string(csv) do
    {:ok, data_stream} =
      csv
      |> StringIO.open()

    data_stream
    |> IO.binstream(:line)
  end

  def index(%{year: nil}) do
    get()
  end

  def index(%{year: year}) do
    {year_as_number, _} = Integer.parse(year)

    # We should get the CSV stream from a .NET Web Service
    # OR
    # get the full known stats from a memory cache if available

    get()
    |> Enum.find(fn x -> x.year == year_as_number end)
  end

  defp get() do
    ConCache.get_or_store(:cache, :current_stats,
    fn() ->
      Logger.debug("not found in cache, downloading now")
      GameStats.Data.Download.get_stream
      |> GameStats.collect_from_csv_stream()
    end)
  end
end
