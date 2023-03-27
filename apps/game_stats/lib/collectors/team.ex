defmodule GameStats.Collectors.Team do
  def initialize do
    %{
      game_count_by_team: %{},
      rating_by_team: %{}
    }
  end

  def collect(game) do
    collect(game, initialize())
  end

  def collect(game, current_stats) do
    current_stats
    |> update_count_by_team(game)
    |> update_rating(game)
  end

  def update_count_by_team(current_stats, %{teamA: teamA, teamB: teamB}) do
    Map.update!(
      current_stats,
      :game_count_by_team,
      fn current_game_count ->
        current_game_count
        |> update_count_by_team("#{teamA.keeper} - #{teamA.striker}")
        |> update_count_by_team("#{teamB.keeper} - #{teamB.striker}")
      end
    )
  end

  def update_count_by_team(count_by_team, team) do
    Map.update(count_by_team, team, 1, fn current -> current + 1 end)
  end

  def update_rating(current_stats, game) do
    teamA_key = "#{game.teamA.keeper} - #{game.teamA.striker}"
    teamB_key = "#{game.teamB.keeper} - #{game.teamB.striker}"
    rating_teamA = Map.get(current_stats.rating_by_team, teamA_key, 400)
    rating_teamB = Map.get(current_stats.rating_by_team, teamB_key, 400)

    Map.update!(
      current_stats,
      :rating_by_team,
      fn current_rating ->
        current_rating
        |> update_rating(
          teamA_key,
          rating_teamA,
          rating_teamB,
          game.score.teamA,
          game.score.teamB
        )
        |> update_rating(
          teamB_key,
          rating_teamB,
          rating_teamA,
          game.score.teamB,
          game.score.teamA
        )
      end
    )
  end

  def update_rating(rating_by_team, team, our_rating, their_rating, our_result, their_result) do
    delta = GameStats.Rating.Elo.update_score(our_result, their_result, our_rating, their_rating)
    Map.update(rating_by_team, team, 400 + delta, fn current -> current + delta end)
  end
end
