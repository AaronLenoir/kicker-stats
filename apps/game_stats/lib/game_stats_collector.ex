defmodule GameStatsCollector do
  alias GameStats.Collectors.Collector
  alias GameStats.Model.Stats
  alias GameStats.Model.Game

  def collect_from_csv_stream(stream) do
    stream
    |> Stream.map(&String.trim(&1))
    |> Stream.map(&Game.parse(&1))
    |> Enum.reduce([], fn game, acc -> collect_from_single_game(acc, game) end)
  end

  defp collect_from_single_game(acc, nil) do
    acc
  end

  defp collect_from_single_game(acc, game) do
    {year, _} = Integer.parse(String.slice(game.date, 6, 4))

    acc
    |> collect_from_single_game(game, nil)
    |> collect_from_single_game(game, year)
  end

  defp collect_from_single_game(acc, game, year) do
    cond do
      Enum.any?(acc, fn x -> x.year == year end) ->
        acc
        |> Enum.map(fn x -> if x.year == year, do: collect(x, game), else: x end)

      true ->
        [collect(Stats.new(year), game) | acc]
    end
  end

  defp collect(current_stats, game) do
    current_stats
    |> Collector.collect(game, GameStats.Collectors.Counters)
    |> Collector.collect(game, GameStats.Collectors.Ratings)
  end
end
