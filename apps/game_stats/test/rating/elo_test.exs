defmodule GameStats.Rating.EloTest do
  use ExUnit.Case
  doctest GameStats.Rating.Elo

  test "win should update base score with 16" do
    new_score = GameStats.Rating.Elo.update_score(10, 0, 400, 400)

    assert new_score == 16
  end

  test "loss should update base score with -16" do
    new_score = GameStats.Rating.Elo.update_score(0, 10, 400, 400)

    assert new_score == 16 * -1
  end
end
