defmodule GameStats.Model.TeamStats do
  @doc """
  Collects stats that relate a team
  """

  alias GameStats.Model.TeamStats

  @derive {Jason.Encoder, only: [:name, :games_played, :games_won, :rating, :streak, :longest_streak]}
  defstruct [
    :name,
    :games_played,
    :games_won,
    :rating,
    :streak,
    :longest_streak
  ]

  @type t :: %TeamStats{}

  @doc """
  Returns a new `GameStats.Collectors.TeamStats` struct for the given player
  """
  def new(name) do
    %TeamStats{name: name, games_played: 0, games_won: 0, rating: 400, streak: 0, longest_streak: 0}
  end
end
