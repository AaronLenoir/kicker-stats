defmodule GameStats.Collectors.Counters do
  @behaviour GameStats.Collectors.Collector
  @doc """
  Collects data related to counters
  """

  alias GameStats.Model.Game
  alias GameStats.Model.Team
  alias GameStats.Model.Stats

  def update(%{} = stats, %Stats{} = _previous, %Game{} = _game) do
    %{stats | games_played: stats.games_played + 1}
  end

  def update(%{} = stats, %Stats{} = previous, %Game{} = game, %Team{} = team) do
    update(stats, previous, game, team, Team.get_name(team))
  end

  def update(%{} = stats, %Stats{} = _previous, %Game{} = game, %Team{} = _team, player) do
    stats
    |> update_games_played()
    |> update_games_won(game, player)
  end

  defp update_games_played(stats) do
    %{stats | games_played: stats.games_played + 1}
  end

  defp update_games_won(stats, game, player) do
    cond do
      Game.won?(game, player) ->
        %{stats | games_won: stats.games_won + 1}

      true ->
        stats
    end
  end
end
