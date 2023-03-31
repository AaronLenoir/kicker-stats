defmodule GameStats do
  alias GameStats.Model.Game

  @derive {Jason.Encoder, only: [:year, :game_stats, :team_stats, :player_stats]}
  defstruct [
    :year,
    :game_stats,
    :team_stats,
    :player_stats
  ]

  @type t :: %GameStats{}

  def new() do
    %GameStats{
      year: nil,
      game_stats: %{},
      team_stats: %{},
      player_stats: %{}
    }
  end

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
        |> Enum.map(fn x -> if x.year == year, do: collect(x, game, year), else: x end)

      true ->
        [collect(new(), game, year) | acc]
    end
  end

  defp collect(current_stats, game, year) do
    %GameStats{
      year: year,
      game_stats: GameStats.Collectors.GameStats.collect(current_stats.game_stats, game),
      team_stats: %{},
      player_stats: GameStats.Collectors.PlayerStats.collect(current_stats.player_stats, game)
    }
  end
end
