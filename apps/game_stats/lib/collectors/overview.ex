defmodule GameStats.Collectors.Overview do
  @behaviour GameStats.Collectors.Collector
  @doc """
  Collects overview data
  """

  alias GameStats.Model.Game
  alias GameStats.Model.Team
  alias GameStats.Model.Stats

  def update(%{} = stats, %Stats{} = _previous, %Game{} = _game) do
    stats
  end

  def update(%{} = stats, %Stats{} = _previous, %Game{} = _game, %Team{} = _team) do
    stats
  end

  def update(%{} = stats, %Stats{} = _previous, %Game{} = _game, %Team{} = _team, _player) do
    stats
  end

  def summary(%Stats{} = stats) do
    %{stats | overview:
      stats.overview
      |> team_ranking(stats.team)
      |> player_ranking(stats.player) }
  end

  defp team_ranking(%{} = overview, %{} = team_stats) do
    ranking =
    Map.keys(team_stats)
    |> Enum.map(fn x -> team_stats[x] end)
    |> Enum.sort(fn x, y -> x.rating >= y.rating end)
    |> Enum.map(fn x -> %{x.name => x.rating} end)

    %{overview | team_ranking: ranking}
  end

  defp player_ranking(%{} = overview, %{} = player_stats) do
    ranking =
    Map.keys(player_stats)
    |> Enum.map(fn x -> player_stats[x] end)
    |> Enum.sort(fn x, y -> x.rating >= y.rating end)
    |> Enum.map(fn x -> %{x.name => x.rating} end)

    %{overview | player_ranking: ranking}
  end

end
