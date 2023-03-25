defmodule GameStats.Collectors.Game do
  def initialize do
    %{game_count: 0}
  end

  def collect(game) do
    collect(game, initialize())
  end

  def collect(_, current_stats) do
    %{game_count: current_stats.game_count + 1}
  end
end
