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
    %{stats | player: update_highest_ranking_team(stats.team, stats.player)}
  end

  defp update_highest_rating(%{rating: rating, highest_rating: highest_rating} = ratings)
      when rating > highest_rating do
    %{ratings | highest_rating: rating}
  end

  defp update_highest_rating(ratings), do: ratings

  defp update_highest_ranking_team(%{} = team_stats, %{} = player_stats) do
    Map.keys(player_stats)
    |> Enum.reduce(player_stats, fn player, acc -> %{acc | player => player_stats[player] |> update_highest_ranking_team(team_stats, player)} end)
  end

  defp update_highest_ranking_team(%PlayerStats{} = stats, %{} = team_stats, player) do
    # TODO: If we have the overview, we have the full team ranking, which is an ordered list
    # so then we can just get the first team with that player instead of doing this contraption here
    first_team = Map.keys(team_stats)
    |> Enum.filter(fn x -> String.contains?(x, player) end)
    |> Enum.sort(fn x, y -> team_stats[x].rating >= team_stats[y].rating end)
    |> List.first()

    %{stats | highest_ranking_team: %{team: first_team, rating: team_stats[first_team].rating}}
  end
end
