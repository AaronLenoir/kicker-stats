defmodule GameStats.Collectors.Ratings do
  @behaviour GameStats.Collectors.Collector

  @doc """
  Collects data related to ratings (Elo)
  """

  alias GameStats.Rating.Elo
  alias GameStats.Model.Game
  alias GameStats.Model.Team
  alias GameStats.Model.Stats
  alias GameStats.Model.TeamStats
  alias GameStats.Model.PlayerStats
  alias GameStats.Model.GameStats

  def update(%GameStats{} = stats, %Stats{} = _previous, %Game{} = _game), do: stats

  def update(%TeamStats{} = stats, %Stats{} = previous, %Game{} = game, %Team{} = team) do
    opponent = Game.find_opponent(game, team)
    opponent_stats = Map.get(previous.team, Team.get_name(opponent), %{rating: 400})

    delta = Elo.update_score(team.score, opponent.score, stats.rating, opponent_stats.rating)

    %{stats | rating: stats.rating + delta}
    |> update_highest_rating()
  end
  def update(
        %PlayerStats{} = stats,
        %Stats{} = previous,
        %Game{} = game,
        %Team{} = team,
        player
      ) do
    opponent = Game.find_opponent(game, player)

    opponent_average =
      ([
         Map.get(previous.player, opponent.keeper, %{rating: 400}),
         Map.get(previous.player, opponent.striker, %{rating: 400})
       ]
       |> Enum.reduce(0, fn stats, acc -> stats.rating + acc end)) / 2

    our_average =
      ([
         Map.get(previous.player, team.keeper, %{rating: 400}),
         Map.get(previous.player, team.striker, %{rating: 400})
       ]
       |> Enum.reduce(0, fn stats, acc -> stats.rating + acc end)) / 2

    delta = Elo.update_score(team.score, opponent.score, our_average, opponent_average)

    %{stats | rating: stats.rating + delta}
    |> update_highest_rating()
  end

  def summary(%Stats{} = stats) do
    %{stats |
      player: update_highest_ranking_team(stats.overview, stats.player)
              |> update_average_team_rating(stats.team)}
  end

  defp update_highest_rating(%{rating: rating, highest_rating: highest_rating} = ratings)
      when rating > highest_rating do
    %{ratings | highest_rating: rating}
  end

  defp update_highest_rating(ratings), do: ratings

  defp update_highest_ranking_team(%{} = overview, %{} = player_stats) do
    Map.keys(player_stats)
    |> Enum.reduce(player_stats, fn player, acc -> %{acc | player => player_stats[player] |> update_highest_ranking_team(overview, player)} end)
  end

  defp update_highest_ranking_team(%PlayerStats{} = stats, %{} = overview, player) do
    {first_team, index} = overview.team_ranking
    |> Enum.with_index()
    |> Enum.filter(fn {x, _} -> Map.keys(x) |> List.first() |> String.contains?(player) end)
    |> List.first()

    %{stats | highest_ranking_team: %{Map.keys(first_team) |> List.first() => index + 1}}
  end

  defp update_average_team_rating(%{} = player_stats, %{} = team_stats) do
    Map.keys(player_stats)
    |> Enum.reduce(player_stats, fn player, acc -> %{acc | player => update_average_team_rating(player_stats[player], team_stats, player)} end)
  end

  defp update_average_team_rating(%PlayerStats{} = stats, %{} = team_stats, player) do
    {count, total_rating} = Map.keys(team_stats)
    |> Enum.filter(fn x -> x |> String.starts_with?("#{player} ") or x |> String.ends_with?(" #{player}") end)
    |> Enum.reduce({0, 0}, fn x, {count, total_rating} -> {count + 1, total_rating + team_stats[x].rating} end)

    %{stats | average_team_rating: total_rating/ count}
  end
end
