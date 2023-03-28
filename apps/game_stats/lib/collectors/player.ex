defmodule GameStats.Collectors.Player do
  def initialize do
    %{
      game_count_by_player: %{},
      rating_by_player: %{},
      streak_by_player: %{}
    }
  end

  def collect(game) do
    collect(game, initialize())
  end

  def collect(game, current_stats) do
    current_stats
    |> update_game_count(game)
    |> update_rating(game)
    |> update_streak(game)
  end

  def update_game_count(current_stats, %{teamA: teamA, teamB: teamB}) do
    Map.update!(
      current_stats,
      :game_count_by_player,
      fn current_game_count ->
        current_game_count
        |> update_game_count(teamA.keeper)
        |> update_game_count(teamA.striker)
        |> update_game_count(teamB.keeper)
        |> update_game_count(teamB.striker)
      end
    )
  end

  def update_game_count(count_by_player, player) do
    Map.update(count_by_player, player, 1, fn current -> current + 1 end)
  end

  def update_rating(current_stats, game) do
    rating_teamA = team_rating(current_stats.rating_by_player, game.teamA)
    rating_teamB = team_rating(current_stats.rating_by_player, game.teamB)

    Map.update!(
      current_stats,
      :rating_by_player,
      fn current_rating ->
        current_rating
        |> update_rating(
          game.teamA.keeper,
          rating_teamA,
          rating_teamB,
          game.score.teamA,
          game.score.teamB
        )
        |> update_rating(
          game.teamA.striker,
          rating_teamA,
          rating_teamB,
          game.score.teamA,
          game.score.teamB
        )
        |> update_rating(
          game.teamB.keeper,
          rating_teamB,
          rating_teamA,
          game.score.teamB,
          game.score.teamA
        )
        |> update_rating(
          game.teamB.striker,
          rating_teamB,
          rating_teamA,
          game.score.teamB,
          game.score.teamA
        )
      end
    )
  end

  def update_rating(rating_by_player, player, our_rating, their_rating, our_result, their_result) do
    delta = GameStats.Rating.Elo.update_score(our_result, their_result, our_rating, their_rating)
    Map.update(rating_by_player, player, 400 + delta, fn current -> current + delta end)
  end

  def team_rating(rating_by_player, %{keeper: keeper, striker: striker}) do
    (Map.get(rating_by_player, keeper, 400) +
       Map.get(rating_by_player, striker, 400)) / 2
  end

  def update_streak(current_stats, game) do

    current_stats
    |> update_streak(game.teamA.keeper, game.score.teamA)
    |> update_streak(game.teamA.striker, game.score.teamA)
    |> update_streak(game.teamB.keeper, game.score.teamB)
    |> update_streak(game.teamB.striker, game.score.teamB)

  end

  def update_streak(current_stats, player, score) do
    current_stats
    |> Map.update!(:streak_by_player, fn x -> update_streak_for_player(x, player, score) end)
  end

  def update_streak_for_player(streak_by_player, player, 10) do
    streak_by_player
    |> Map.update(player, %{current: 1, highest: 1}, fn
        x when x.current + 1 > x.highest -> %{current: x.current + 1, highest: x.current + 1}
        x -> %{current: x.current + 1, highest: x.highest}
      end)
  end

  def update_streak_for_player(streak_by_player, player, _) do
    streak_by_player
    |> Map.update(player, %{current: 1, highest: 1}, fn x -> %{current: 0, highest: x.highest} end)
  end

end
