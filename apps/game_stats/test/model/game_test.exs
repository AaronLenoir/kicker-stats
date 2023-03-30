defmodule GameStats.Model.GameTest do
  use ExUnit.Case
  doctest GameStats.Model.Game

  import GameStats.Model.Game

  test "parse with invalid csv returns nil", do: assert(nil == parse("this;is;not;a;game"))

  test "parse with invalid score returns nil",
    do: assert(nil == parse("01/01/2020;Player A;Player B;XX;YY;Player C;Player D"))

  test "parse with valid game reads teams and score correctly" do
    game = parse("01/01/2020;Player A;Player B;2;10;Player C;Player D")

    assert game.teamA.keeper == "Player A"
    assert game.teamA.striker == "Player B"
    assert game.teamB.keeper == "Player C"
    assert game.teamB.striker == "Player D"

    assert game.teamA.score == 2
    assert game.teamB.score == 10
  end

  test "won? returns true if player has won, false otherwise" do
    assert won?(%{date: "01/01/2023", teamA: %{keeper: "Player A", score: 10}}, "Player A")
    assert won?(%{date: "01/01/2023", teamA: %{striker: "Player A", score: 10}}, "Player A")
    assert not won?(%{date: "01/01/2023", teamA: %{keeper: "Player A", score: 9}}, "Player A")
    assert not won?(%{date: "01/01/2023", teamA: %{striker: "Player A", score: 9}}, "Player A")

    assert won?(%{date: "01/01/2023", teamB: %{keeper: "Player A", score: 10}}, "Player A")
    assert won?(%{date: "01/01/2023", teamB: %{striker: "Player A", score: 10}}, "Player A")
    assert not won?(%{date: "01/01/2023", teamB: %{keeper: "Player A", score: 9}}, "Player A")
    assert not won?(%{date: "01/01/2023", teamB: %{striker: "Player A", score: 9}}, "Player A")
  end
end
