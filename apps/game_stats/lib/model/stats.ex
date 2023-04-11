defmodule GameStats.Model.Stats do
  @doc """
  Holds stats about Games, Players, Team ...
  """

  alias GameStats.Model.Stats
  alias GameStats.Model.GameStats

  @derive {Jason.Encoder, only: [:year, :game, :team, :player, :overview]}
  defstruct [
    :year,
    :game,
    :team,
    :player,
    :overview
  ]

  @type t :: %Stats{}

  def new(), do: new(nil)

  def new(year) do
    %Stats{
      year: year,
      game: GameStats.new(),
      team: %{},
      player: %{},
      overview: %{team_ranking: [], player_ranking: []}
    }
  end
end
