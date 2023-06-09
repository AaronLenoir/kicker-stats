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
    |> update_goals_allowed(game, player)
  end

  def summary(%Stats{} = stats) do
    stats
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

  defp update_goals_allowed(stats, game, %Team{} = team) do
    %{stats | goals_allowed: stats.goals_allowed + Game.find_opponent(game, team).score}
  end

  defp update_goals_allowed(stats, game, player) do
    team = Game.find_team(game, player)

    case team do
      %Team{keeper: _, striker: ^player} ->
        stats

      %Team{keeper: ^player, striker: _} ->
        %{stats |
            games_as_keeper: stats.games_as_keeper + 1,
            goals_allowed: stats.goals_allowed + Game.find_opponent(game, player).score
        }

      _ ->
        stats
    end
  end
end
