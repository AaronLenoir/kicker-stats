defmodule GameStats.Model.PlayerStats do
  @doc """
  Collects stats that relate a single players
  """

  alias GameStats.Model.PlayerStats

  @derive {Jason.Encoder,
           only: [
             :name,
             :games_played,
             :games_won,
             :rating,
             :highest_rating,
             :streak,
             :longest_streak,
             :games_as_keeper,
             :goals_allowed,
             :highest_ranking_team
           ]}
  defstruct [
    :name,
    :games_played,
    :games_won,
    :rating,
    :highest_rating,
    :streak,
    :longest_streak,
    :games_as_keeper,
    :goals_allowed,
    :highest_ranking_team
  ]

  @type t :: %PlayerStats{}

  @doc """
  Returns a new `GameStats.Collectors.PlayerStats` struct for the given player
  """
  def new(player) do
    %PlayerStats{
      name: player,
      games_played: 0,
      games_won: 0,
      rating: 400,
      highest_rating: 400,
      streak: 0,
      longest_streak: 0,
      games_as_keeper: 0,
      goals_allowed: 0,
      highest_ranking_team: %{}
    }
  end
end
