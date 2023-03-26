defmodule GameStats.Test.Helper do
  def get_stream_from_string(csv) do
    {:ok, data_stream} =
      csv
      |> StringIO.open()

    data_stream
    |> IO.binstream(:line)
  end

  def start_dummy_cache do
    children = [
      %{
        id: :dummy_cache,
        start: {ConCache, :start_link, [[name: :dummy_cache, ttl_check_interval: false]]}
      }
    ]

    Supervisor.start_link(children, strategy: :one_for_one)
  end
end

ExUnit.configure(exclude: [perf: true, online: true])
ExUnit.start()
