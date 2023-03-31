defmodule GameStats.Collectors.PlayerStatsRatingTest do
  use ExUnit.Case

  import GameStats.Collectors.PlayerStatsRating
  alias GameStats.Model.Game

  test "collect calculates rating for each player" do
    stats = collect(%{}, Game.parse("01/01/2023;Player A;Player B;10;0;Player C;Player D"))

    assert stats["Player A"].rating == 400 + 16
    assert stats["Player B"].rating == 400 + 16
    assert stats["Player C"].rating == 400 - 16
    assert stats["Player D"].rating == 400 - 16
  end

  test "Two wins in a row, starting from default, results in a 400 + 31 rating" do
    stats =
      collect(%{}, Game.parse("01/01/2023;Player A;Player B;10;0;Player C;Player D"))
      |> collect(Game.parse("01/01/2023;Player A;Player B;10;0;Player C;Player D"))

    assert stats["Player A"].rating == 400 + 31
  end

  test "Two losses in a row, starting from default, results in a 400 - 31 rating" do
    stats =
      collect(%{}, Game.parse("01/01/2023;Player A;Player B;0;10;Player C;Player D"))
      |> collect(Game.parse("01/01/2023;Player A;Player B;0;10;Player C;Player D"))

    assert stats["Player A"].rating == 400 - 31
  end
end
