defmodule GameStats do
  @initial_stats %{
    year: nil,
    game_stats: GameStats.Collectors.Game.initialize(),
    player_stats: GameStats.Collectors.Player.initialize(),
    team_stats: GameStats.Collectors.Team.initialize()
  }

  def collect_from_csv_stream(stream) do
    stream
    |> Stream.map(&String.trim(&1))
    |> Stream.map(&parse_game(&1))
    |> Enum.reduce([], fn game, acc -> collect_from_single_game(acc, game) end)
    |> GameStats.Collectors.Overview.collect()
  end

  def parse_game(csv) when is_binary(csv) do
    String.split(csv, ";")
    |> parse_game()
  end

  def parse_game([date, keeperA, strikerA, scoreA, scoreB, keeperB, strikerB])
      when is_binary(scoreA) and is_binary(scoreB) do
    parse_game([
      date,
      keeperA,
      strikerA,
      Integer.parse(scoreA),
      Integer.parse(scoreB),
      keeperB,
      strikerB
    ])
  end

  def parse_game([_, _, _, :error, :error, _, _]) do
    # No valid numbers in the score ... cannot continue
    nil
  end

  def parse_game([date, keeperA, strikerA, {scoreA, _}, {scoreB, _}, keeperB, strikerB])
      when is_integer(scoreA) and is_integer(scoreB) do
    %{
      date: date,
      teamA: %{keeper: keeperA, striker: strikerA},
      teamB: %{keeper: keeperB, striker: strikerB},
      score: %{teamA: scoreA, teamB: scoreB}
    }
  end

  def parse_game(_) do
    nil
  end

  def collect_from_single_game(acc, nil) do
    acc
  end

  def collect_from_single_game(acc, game) do
    {year, _} = Integer.parse(String.slice(game.date, 6, 4))

    acc
    |> collect_from_single_game(game, year)
    |> collect_from_single_game(game, nil)
  end

  def collect_from_single_game(acc, game, year) do
    if Enum.any?(acc, fn x -> x.year == year end) do
      acc
      |> Enum.map(fn x -> if x.year == year, do: collect(x, game, year), else: x end)
    else
      [collect(@initial_stats, game, year) | acc]
    end
  end

  def collect(current_stats, game, year) do
    %{
      year: year,
      game_stats: GameStats.Collectors.Game.collect(game, current_stats.game_stats),
      player_stats: GameStats.Collectors.Player.collect(game, current_stats.player_stats),
      team_stats: GameStats.Collectors.Team.collect(game, current_stats.team_stats)
    }
  end
end
