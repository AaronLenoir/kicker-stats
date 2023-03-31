defmodule GameStats.Collectors.PlayerStatsRating do
  @doc """
  Collects player ratings
  """

  alias GameStats.Collectors.PlayerStats
  alias GameStats.Model.Game
  alias GameStats.Rating.Elo

  def collect(current, game) do
    collect(current, Game.find_winners(game), Game.find_losers(game))
  end

  defp collect(current, winners, losers) do
    winners_rating = get_team_rating(current, winners)
    losers_rating = get_team_rating(current, losers)

    delta = Elo.update_score(winners.score, losers.score, winners_rating, losers_rating)

    [
      {:winner, winners.keeper},
      {:winner, winners.striker},
      {:loser, losers.keeper},
      {:loser, losers.striker}
    ]
    |> Enum.reduce(current, fn
      {:winner, player}, acc -> acc |> update_rating(player, delta)
      {:loser, player}, acc -> acc |> update_rating(player, delta * -1)
    end)
  end

  defp get_team_rating(current, team) do
    ((current
      |> get_rating(team.keeper)) +
       (current
        |> get_rating(team.striker))) / 2
  end

  defp get_rating(current, player), do: Map.get(current, player, %{rating: 400}).rating

  defp update_rating(current, player, delta) do
    current
    |> Map.update(
      player,
      %{PlayerStats.new(player) | rating: 400 + delta},
      fn stats -> %{stats | rating: stats.rating + delta} end
    )
  end
end
