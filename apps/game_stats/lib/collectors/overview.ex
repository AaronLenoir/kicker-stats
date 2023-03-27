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
        player_ranking: collect_ranking(head),
        team_ranking: collect_ranking(head)
      })

    collect(tail, [updated_stats | stats])
  end

  defp collect_ranking(%{player_stats: player_stats}) do
    Map.keys(player_stats.rating_by_player)
    |> Enum.filter(fn player -> player_stats.game_count_by_player[player] >= 10 end)
    |> Enum.map(fn player -> %{player: player, rating: player_stats.rating_by_player[player]} end)
    |> Enum.sort_by(fn x -> x.rating end, :desc)
  end

  defp collect_ranking(%{team_stats: team_stats}) do
    Map.keys(team_stats.rating_by_team)
    |> Enum.map(fn team -> %{team: team, rating: team_stats.rating_by_team[team]} end)
    |> Enum.sort_by(fn x -> x.rating end, :desc)
  end

end
