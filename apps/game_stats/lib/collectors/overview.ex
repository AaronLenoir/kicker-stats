defmodule GameStats.Collectors.Overview do
  def initialize do
    %{player_ranking: []}
  end

  def collect(list) do
    collect(list, [])
  end

  def collect([], stats) do
    stats
  end

  def collect([head | tail], stats) do
    updated_stats =
      head
      |> Map.put(:overview, %{
        player_ranking: collect_ranking(head.player_stats),
        team_ranking: collect_ranking(head.team_stats)
      })

    collect(tail, [updated_stats | stats])
  end

  defp collect_ranking(%{game_count_by_player: game_count_by_player, rating_by_player: rating_by_player}) do
    Map.keys(rating_by_player)
    |> Enum.filter(fn player -> game_count_by_player[player] >= 10 end)
    |> Enum.map(fn player -> %{player: player, rating: rating_by_player[player]} end)
    |> Enum.sort_by(fn x -> x.rating end, :desc)
  end

  defp collect_ranking(%{rating_by_team: rating_by_team}) do
    Map.keys(rating_by_team)
    |> Enum.map(fn team -> %{team: team, rating: rating_by_team[team]} end)
    |> Enum.sort_by(fn x -> x.rating end, :desc)
  end

end
