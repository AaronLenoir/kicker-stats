defmodule GameStats.Model.Game do
  @doc """
  Information on a single game
  """

  alias GameStats.Model.Game
  alias GameStats.Model.Team

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
      teamA: %Team{keeper: keeperA, striker: strikerA, score: scoreA},
      teamB: %Team{keeper: keeperB, striker: strikerB, score: scoreB}
    }
  end

  def parse([_, _, _, :error, :error, _, _]), do: nil

  def parse(_), do: nil

  @doc """
  Check if a given player or team has won the game
  """
  def won?(%{teamA: %{keeper: player, score: scoreA}, teamB: %{score: scoreB}}, player)
      when scoreA > scoreB,
      do: true

  def won?(%{teamA: %{striker: player, score: scoreA}, teamB: %{score: scoreB}}, player)
      when scoreA > scoreB,
      do: true

  def won?(%{teamB: %{keeper: player, score: scoreB}, teamA: %{score: scoreA}}, player)
      when scoreB > scoreA,
      do: true

  def won?(%{teamB: %{striker: player, score: scoreB}, teamA: %{score: scoreA}}, player)
      when scoreB > scoreA,
      do: true

  def won?(
        %{teamA: teamA, teamB: %{score: scoreB}},
        %Team{keeper: _keeper, striker: _striker, score: score} = teamA
      )
      when score > scoreB,
      do: true

  def won?(
        %{teamB: %{keeper: keeper, striker: striker, score: scoreB}, teamA: %{score: scoreA}},
        %Team{keeper: keeper, striker: striker}
      )
      when scoreB > scoreA,
      do: true

  def won?(_game, _player) do
    false
  end

  @doc """
  Finds the team for the given played
  """
  def find_team(%{teamA: %{keeper: player}} = game, player), do: game.teamA
  def find_team(%{teamA: %{striker: player}} = game, player), do: game.teamA
  def find_team(%{teamB: %{keeper: player}} = game, player), do: game.teamB
  def find_team(%{teamB: %{striker: player}} = game, player), do: game.teamB
  def find_team(_, player), do: {:error, "no team for player #{player}"}

  def find_opponent(%{teamA: %{keeper: keeper, striker: striker}} = game, %Team{
        keeper: keeper,
        striker: striker
      }),
      do: game.teamB

  def find_opponent(%{teamB: %{keeper: keeper, striker: striker}} = game, %Team{
        keeper: keeper,
        striker: striker
      }),
      do: game.teamA

  def find_opponent(%{teamA: %{keeper: player}} = game, player), do: game.teamB
  def find_opponent(%{teamA: %{striker: player}} = game, player), do: game.teamB
  def find_opponent(%{teamB: %{keeper: player}} = game, player), do: game.teamA
  def find_opponent(%{teamB: %{striker: player}} = game, player), do: game.teamA
  def find_opponent(_, player), do: {:error, "no team for player #{player}"}

  def list_players(%Game{} = game),
    do: [game.teamA.keeper, game.teamA.striker, game.teamB.keeper, game.teamB.striker]

  def find_winners(%{teamA: %{score: 10}} = game), do: game.teamA
  def find_winners(%{teamB: %{score: 10}} = game), do: game.teamB
  def find_losers(%{teamA: %{score: score}} = game) when score < 10, do: game.teamA
  def find_losers(%{teamB: %{score: score}} = game) when score < 10, do: game.teamB
end
