defmodule GameStats.Data.Updater do
  use GenServer
  require Logger

  def start_link(state) do
    GenServer.start_link(__MODULE__, state)
  end

  def init(state) do
    schedule_work(state.interval)
    {:ok, state}
  end

  def handle_info(:work, state) do
    update(state.get, state.cache_name)

    schedule_work(state.interval)
    {:noreply, state}
  end

  defp update(get_stream, cache_name) do
    Logger.info("updating cache #{cache_name}")

    stats =
      get_stream.()
      |> GameStatsCollector.collect_from_csv_stream()

    ConCache.put(cache_name, :current_stats, stats)
  end

  defp schedule_work(interval) do
    Process.send_after(self(), :work, interval)
  end
end
