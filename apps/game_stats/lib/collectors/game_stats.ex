defmodule GameStats.Collectors.GameStats do
  @doc """
  Collects stats that relate games in general
  """

  alias GameStats.Collectors.GameStats

  @derive {Jason.Encoder, only: [:games_played]}
  defstruct [
    :games_played
  ]

  @type t :: %GameStats{}

  def new() do
    %GameStats{games_played: 0}
  end

  @doc """
  Updates the given collection of game stats based on the given game
  """
  def collect(current, _game) when is_map(current) do
    current
    |> Map.update(:games_played, 1, fn games_played ->
      games_played + 1
    end)
  end
end
