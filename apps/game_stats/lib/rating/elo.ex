defmodule GameStats.Rating.Elo do
  @factor 400
  @k_factor 32

  def update_score(our_score, their_score, our_rating, their_rating) do
    qa = :math.pow(10, our_rating / @factor)
    qb = :math.pow(10, their_rating / @factor)

    expected_result = qa / (qa + qb)

    our_result = if our_score > their_score, do: 1, else: 0

    round(@k_factor * (our_result - expected_result))
  end
end
