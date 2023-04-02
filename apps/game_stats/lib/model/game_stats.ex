defmodule GameStats.Model.GameStats do
  @doc """
  Stats that relate to games in general
  """

  alias GameStats.Model.GameStats

  @derive {Jason.Encoder, only: [:games_played]}
  defstruct [
    :games_played
  ]

  @type t :: %GameStats{}

  def new() do
    %GameStats{games_played: 0}
  end
end
