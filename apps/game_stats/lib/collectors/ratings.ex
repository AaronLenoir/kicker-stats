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
    ([Map.get(previous.player, opponent.keeper, %{rating: 400}),
      Map.get(previous.player, opponent.striker, %{rating: 400})]
    |> Enum.reduce(0, fn stats, acc -> stats.rating + acc end)) /2

    our_average =
    ([Map.get(previous.player, team.keeper, %{rating: 400}),
      Map.get(previous.player, team.striker, %{rating: 400})]
    |> Enum.reduce(0, fn stats, acc -> stats.rating + acc end)) /2

    delta = Elo.update_score(team.score, opponent.score, our_average, opponent_average)

    %{stats | rating: stats.rating + delta}
  end
end
