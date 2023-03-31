defmodule GameStats.Collectors.PlayerStats do
  @doc """
  Collects stats that relate a single players
  """

  alias GameStats.Collectors.PlayerStats
  alias GameStats.Collectors.PlayerStatsRating
  alias GameStats.Model.Game

  @derive {Jason.Encoder, only: [:name, :games_played, :games_won, :rating]}
  defstruct [
    :name,
    :games_played,
    :games_won,
    :rating
  ]

  @type t :: %PlayerStats{}

  @doc """
  Returns a new `GameStats.Collectors.PlayerStats` struct for the given player
  """
  def new(player) do
    %PlayerStats{name: player, games_played: 0, games_won: 0, rating: 400}
  end

  @doc """
  Updates the given collection of user stats based on the given game
  """
  def collect(current, %Game{} = game) when is_map(current) do
    current
    |> PlayerStatsRating.collect(game)
    |> collect(game, [
      game.teamA.keeper,
      game.teamA.striker,
      game.teamB.keeper,
      game.teamB.striker
    ])
  end

  defp collect(current, _game, []), do: current

  defp collect(current, game, [player | others]) do
    current
    |> collect_games_played(player)
    |> collect_games_won(game, player)
    |> collect(game, others)
  end

  defp collect_games_played(current, player) do
    current
    |> Map.update(player, %{new(player) | games_played: 1}, fn stats ->
      %{stats | games_played: stats.games_played + 1}
    end)
  end

  defp collect_games_won(current, game, player) do
    cond do
      Game.won?(game, player) ->
        current
        |> Map.update(player, %{new(player) | games_won: 1}, fn stats ->
          %{stats | games_won: stats.games_won + 1}
        end)

      true ->
        current
    end
  end
end
