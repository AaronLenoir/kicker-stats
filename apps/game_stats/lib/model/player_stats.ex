defmodule GameStats.Model.PlayerStats do
  @doc """
  Collects stats that relate a single players
  """

  alias GameStats.Model.PlayerStats

  @derive {Jason.Encoder, only: [:name, :games_played, :games_won, :rating, :streak, :longest_streak]}
  defstruct [
    :name,
    :games_played,
    :games_won,
    :rating,
    :streak,
    :longest_streak
  ]

  @type t :: %PlayerStats{}

  @doc """
  Returns a new `GameStats.Collectors.PlayerStats` struct for the given player
  """
  def new(player) do
    %PlayerStats{name: player, games_played: 0, games_won: 0, rating: 400, streak: 0, longest_streak: 0}
  end
end