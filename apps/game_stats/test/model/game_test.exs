defmodule GameStats.Model.GameTest do
  use ExUnit.Case
  doctest GameStats.Model.Game

  import GameStats.Model.Game
  alias GameStats.Model.Team

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
    assert won?(parse("01/01/2020;Player A;Player B;10;0;Player C;Player D"), "Player A")
    assert won?(parse("01/01/2020;Player B;Player A;10;0;Player C;Player D"), "Player A")
    assert won?(parse("01/01/2020;Player B;Player C;0;10;Player A;Player D"), "Player A")
    assert won?(parse("01/01/2020;Player B;Player C;0;10;Player D;Player A"), "Player A")
    assert not won?(parse("01/01/2020;Player A;Player B;0;10;Player C;Player D"), "Player A")
    assert not won?(parse("01/01/2020;Player B;Player A;0;10;Player C;Player D"), "Player A")
  end

  test "won? returns true if player has won, false otherwise also with greater than 10 results" do
    assert won?(
             %{
               date: "01/01/2023",
               teamA: %{keeper: "Player A", score: 14},
               teamB: %{keeper: "Player B", score: 12}
             },
             "Player A"
           )
  end

  test "won? returns true if team has won, false otherwise" do
    game = parse("01/01/2020;Player A;Player B;10;0;Player C;Player D")
    assert won?(game, game.teamA)
    assert not won?(game, game.teamB)
  end

  test "won? returns true if team has won, false otherwise even with greater than 10 results" do
    game = parse("01/01/2020;Player A;Player B;17;19;Player C;Player D")
    assert not won?(game, game.teamA)
    assert won?(game, game.teamB)
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

  test "find_opponent for player not in the game returns error" do
    {:error, _} =
      find_opponent(parse("01/01/2020;Player A;Player B;2;10;Player C;Player D"), "Player X")
  end

  test "find_opponent with team finds the correct opponent team" do
    game = parse("01/01/2020;Player A;Player B;2;10;Player C;Player D")

    teamB = find_opponent(game, %Team{keeper: "Player A", striker: "Player B"})
    teamA = find_opponent(game, %Team{keeper: "Player C", striker: "Player D"})

    assert teamA.keeper == "Player A" and teamA.striker == "Player B"
    assert teamB.keeper == "Player C" and teamB.striker == "Player D"
  end

  test "list_players returns all player names for a game in a List" do
    [playerA, playerB, playerC, playerD] =
      list_players(parse("01/01/2020;Player A;Player B;2;10;Player C;Player D"))

    assert playerA == "Player A"
    assert playerB == "Player B"
    assert playerC == "Player C"
    assert playerD == "Player D"
  end
end
