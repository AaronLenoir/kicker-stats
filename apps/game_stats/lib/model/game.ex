defmodule GameStats.Model.Game do
  @doc """
  Information on a single game
  """

  alias GameStats.Model.Game

  defstruct [
    :date,
    :teamA,
    :teamB
  ]

  @type t :: %Game{}

  @doc """
  Creates a `GameStats.Model.Game` struct based on the given line of csv
  """
  def parse(csv) when is_binary(csv) do
    String.split(csv, ";")
    |> parse()
  end

  def parse([date, keeperA, strikerA, scoreA, scoreB, keeperB, strikerB])
      when is_binary(scoreA) and is_binary(scoreB) do
    parse([
      date,
      keeperA,
      strikerA,
      Integer.parse(scoreA),
      Integer.parse(scoreB),
      keeperB,
      strikerB
    ])
  end

  def parse([date, keeperA, strikerA, {scoreA, _}, {scoreB, _}, keeperB, strikerB])
      when is_integer(scoreA) and is_integer(scoreB) do
    %Game{
      date: date,
      teamA: %{keeper: keeperA, striker: strikerA, score: scoreA},
      teamB: %{keeper: keeperB, striker: strikerB, score: scoreB}
    }
  end

  def parse([_, _, _, :error, :error, _, _]), do: nil

  def parse(_), do: nil

  @doc """
  Check if a given player has won the game
  """
  def won?(%{teamA: %{keeper: player, score: 10}}, player), do: true
  def won?(%{teamA: %{striker: player, score: 10}}, player), do: true
  def won?(%{teamB: %{keeper: player, score: 10}}, player), do: true
  def won?(%{teamB: %{striker: player, score: 10}}, player), do: true
  def won?(_game, _player), do: false
end
