defmodule GameStats.Collectors.PlayerStats do
  @doc """
  Collects stats that relate single players
  """

  alias GameStats.Collectors.PlayerStats

  @derive {Jason.Encoder, only: [:name, :games_played]}
  defstruct [
    :name,
    :games_played
  ]

  @type t :: %PlayerStats{}

  @doc """
  Returns a new `GameStats.Collectors.PlayerStats` struct for the given player
  """
  def new(player) do
    %PlayerStats{name: player, games_played: 1}
  end

  @doc """
  Updates the given collection of user stats based on the given game
  """
  def collect(current, game) do
    current
    |> collect_games_played([game.teamA.keeper, game.teamA.striker, game.teamB.keeper, game.teamB.striker])
  end

  defp collect_games_played(current, []) do
    current
  end

  defp collect_games_played(current, [player | others]) do
    current
    |> Map.update(player, new(player), fn stats -> update(stats, :games_played, stats.games_played + 1) end)
    |> collect_games_played(others)
  end

  defp update(stats, key, value) do
    stats
    |> Map.update!(key, fn _ -> value end)
  end

end
