defmodule GameStats.Collectors.Collector do
  @doc """
  Calls a given collector's update
  """

  alias GameStats.Model.Game
  alias GameStats.Model.Stats
  alias GameStats.Model.Team
  alias GameStats.Model.TeamStats
  alias GameStats.Model.PlayerStats
  alias GameStats.Model.GameStats

  @callback update(%GameStats{}, %Stats{}, %Game{}) :: %GameStats{}
  @callback update(%TeamStats{}, %Stats{}, %Game{}, %Team{}) :: %TeamStats{}
  @callback update(%PlayerStats{}, %Stats{}, %Game{}, %Team{}, String.t()) :: %PlayerStats{}

  @callback summary(%Stats{}) :: %Stats{}

  def collect(%Stats{} = stats, %Game{} = game, implementation) do
    stats
    |> collect_game_stats(game, &implementation.update/3)
    |> collect_team_stats(game, &implementation.update/4)
    |> collect_player_stats(game, &implementation.update/5)
  end

  def summary(%Stats{} = stats, implementation) do
    stats
    |> implementation.summary()
  end

  defp collect_game_stats(%Stats{} = stats, game, fun) do
    stats
    |> Map.update(:game, GameStats.new(), fn game_stats ->
      game_stats |> collect_game_stats(stats, game, fun)
    end)
  end

  defp collect_game_stats(stats, %Stats{} = previous, game, fun) do
    stats
    |> fun.(previous, game)
  end

  defp collect_player_stats(%Stats{} = stats, %Game{} = game, fun) do
    stats
    |> Map.update(:player, %{}, fn player_stats ->
      player_stats |> collect_player_stats(stats, game, fun)
    end)
  end

  defp collect_player_stats(stats, %Stats{} = previous, game, fun) do
    Game.list_players(game)
    |> Enum.map(fn player -> stats |> Map.get(player, PlayerStats.new(player)) end)
    |> Enum.map(fn player_stats ->
      player_stats
      |> fun.(previous, game, Game.find_team(game, player_stats.name), player_stats.name)
    end)
    |> Enum.reduce(stats, fn player_stats, acc ->
      acc |> Map.put(player_stats.name, player_stats)
    end)
  end

  defp collect_team_stats(%Stats{} = stats, %Game{} = game, fun) do
    stats
    |> Map.update(:team, %{}, fn team_stats ->
      team_stats |> collect_team_stats(stats, game, fun)
    end)
  end

  defp collect_team_stats(stats, %Stats{} = previous, game, fun) do
    [
      %{name: Team.get_name(game.teamA), team: game.teamA},
      %{name: Team.get_name(game.teamB), team: game.teamB}
    ]
    |> Enum.map(fn team ->
      %{team: team.team, stats: Map.get(stats, team.name, TeamStats.new(team.name))}
    end)
    |> Enum.map(fn team -> team.stats |> fun.(previous, game, team.team) end)
    |> Enum.reduce(stats, fn team_stats, acc -> acc |> Map.put(team_stats.name, team_stats) end)
  end
end
