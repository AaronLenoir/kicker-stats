defmodule GameStats.Model.Stats do
  @doc """
  Holds stats about Games, Players, Team ...
  """

  alias GameStats.Model.Stats
  alias GameStats.Model.GameStats

  @derive {Jason.Encoder, only: [:year, :game, :team, :player]}
  defstruct [
    :year,
    :game,
    :team,
    :player
  ]

  @type t :: %Stats{}

  def new(), do: new(nil)

  def new(year) do
    %Stats{
      year: year,
      game: GameStats.new(),
      team: %{},
      player: %{}
    }
  end
end
