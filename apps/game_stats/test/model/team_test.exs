defmodule GameStats.Model.TeamTest do
  use ExUnit.Case
  doctest GameStats.Model.Team

  alias GameStats.Model.Game
  import GameStats.Model.Team

  test "get_name gets name of team in format keeper - striker" do
    game = Game.parse("01/01/2020;Player A;Player B;2;10;Player C;Player D")

    assert get_name(game.teamA) == "Player A - Player B"
    assert get_name(game.teamB) == "Player C - Player D"
  end
end
