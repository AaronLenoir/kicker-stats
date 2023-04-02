defmodule GameStats.Collectors.Ratings do
  @behaviour GameStats.Collectors.Collector

  @doc """
  Collects data related to ratings (Elo)
  """

  alias GameStats.Model.Game
  alias GameStats.Model.Team
  alias GameStats.Model.Stats
  alias GameStats.Model.TeamStats
  alias GameStats.Model.PlayerStats
  alias GameStats.Model.GameStats

  def update(%GameStats{} = stats, %Stats{} = _previous, %Game{} = _game), do: stats

  def update(%TeamStats{} = stats, %Stats{} = _previous, %Game{} = _game, %Team{} = _team),
    do: stats

  def update(
        %PlayerStats{} = stats,
        %Stats{} = _previous,
        %Game{} = _game,
        %Team{} = _team,
        _player
      ) do
    %{stats | rating: 416}
  end
end
