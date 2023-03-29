defmodule GameStats.Collectors.PlayerStats do
  @doc """
  Collects stats that relate single players
  """

  alias GameStats.Collectors.PlayerStats

  @derive {Jason.Encoder, only: [:name, :games_played]}
  defstruct [
    :name,
    :games_played,
    :games_won
  ]

  @type t :: %PlayerStats{}

  @doc """
  Returns a new `GameStats.Collectors.PlayerStats` struct for the given player
  """
  def new(player) do
    %PlayerStats{name: player, games_played: 0, games_won: 0}
  end

  @doc """
  Updates the given collection of user stats based on the given game
  """
  def collect(current, game) do
    current
    |> collect(game, [game.teamA.keeper, game.teamA.striker, game.teamB.keeper, game.teamB.striker])
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
    |> Map.update(player, %{new(player) | games_played: 1}, fn stats -> update(stats, :games_played, stats.games_played + 1) end)
  end

  defp collect_games_won(current, game, player) do
    if player_won(game, player) do
      current
      |> Map.update(player, %{new(player) | games_won: 1}, fn stats -> update(stats, :games_won, stats.games_won + 1) end)
    else
      current
    end

  end

  # TODO: Move this to the Game module (also, make the Game module)
  defp player_won(game, player) do
    case game do
      %{teamA: %{keeper: ^player}, score: %{teamA: 10}} ->
        true
      %{teamA: %{striker: ^player}, score: %{teamA: 10}} ->
        true
      %{teamB: %{striker: ^player}, score: %{teamB: 10}} ->
        true
      %{teamB: %{striker: ^player}, score: %{teamB: 10}} ->
        true
      _ ->
        false
    end
  end

  defp update(stats, key, value) do
    stats
    |> Map.update!(key, fn _ -> value end)
  end

end
