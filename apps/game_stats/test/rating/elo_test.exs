defmodule GameStats.Rating.EloTest do
  use ExUnit.Case
  doctest GameStats.Rating.Elo

  test "win should update base score with 16" do
    delta = GameStats.Rating.Elo.update_score(10, 0, 400, 400)

    assert delta == 16
  end

  test "loss should update base score with -16" do
    delta = GameStats.Rating.Elo.update_score(0, 10, 400, 400)

    assert delta == 16 * -1
  end

  test "two wins should update score from 400 to 431" do
    delta = GameStats.Rating.Elo.update_score(10, 0, 416, 384)

    assert delta == 431 - 416
  end
end
