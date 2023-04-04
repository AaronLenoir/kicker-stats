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
    update(stats, previous, game, team, team)
  end

  def update(%{} = stats, %Stats{} = _previous, %Game{} = game, %Team{} = _team, player) do
    stats
    |> update_games_played()
    |> update_games_won(game, player)
    |> update_streak(game, player)
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

  defp update_streak(stats, game, player) do
    cond do
      Game.won?(game, player) and stats.streak + 1 > stats.longest_streak ->
        %{stats | streak: stats.streak + 1, longest_streak: stats.longest_streak + 1}

      Game.won?(game, player) ->
        %{stats | streak: stats.streak + 1}

      true ->
        %{stats | streak: 0}
    end
  end
end
