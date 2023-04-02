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

  test "won? returns true if team has won, false otherwise" do
    assert won?(%{date: "01/01/2023", teamA: %{keeper: "Player A", score: 10}}, %{
             keeper: "Player A",
             striker: "Player B",
             score: 10
           })

    assert not won?(%{date: "01/01/2023", teamA: %{keeper: "Player A", score: 10}}, %{
             keeper: "Player A",
             striker: "Player B",
             score: 9
           })
  end

  test "find_team finds the correct team" do
    team = find_team(parse("01/01/2020;Player A;Player B;2;10;Player C;Player D"), "Player A")
    assert team.keeper == "Player A" and team.striker == "Player B"
  end

  test "find_team for player not in the game returns error" do
    {:error, _} =
      find_team(parse("01/01/2020;Player A;Player B;2;10;Player C;Player D"), "Player X")
  end

  test "find_opponent finds the correct team" do
    team = find_opponent(parse("01/01/2020;Player A;Player B;2;10;Player C;Player D"), "Player A")
    assert team.keeper == "Player C" and team.striker == "Player D"
  end

  test "find_opponet for player not in the game returns error" do
    {:error, _} =
      find_opponent(parse("01/01/2020;Player A;Player B;2;10;Player C;Player D"), "Player X")
  end

  test "list_players returns all player names for a game in a List" do
    [playerA, playerB, playerC, playerD] =
      list_players(parse("01/01/2020;Player A;Player B;2;10;Player C;Player D"))

    assert playerA == "Player A"
    assert playerB == "Player B"
    assert playerC == "Player C"
    assert playerD == "Player D"
  end

  test "find_winners returns teamA as winner (if they won)" do
    %{keeper: "Player A", striker: "Player B"} =
      find_winners(parse("01/01/2020;Player A;Player B;10;2;Player C;Player D"))
  end

  test "find_losers returns teamB as loser (if they lost)" do
    %{keeper: "Player C", striker: "Player D"} =
      find_losers(parse("01/01/2020;Player A;Player B;10;2;Player C;Player D"))
  end
end
