defmodule GameStats.Data.Download do
  @url "http://kicker/api/results/csv"

  def get_stream() do
    HTTPStream.get(@url)
    |> lines()
  end

  defp lines(enum) do
    enum
    |> Stream.transform("", fn
      :end, acc ->
        {[acc], ""}

      chunk, acc ->
        [last_line | lines] =
          String.split(acc <> chunk, "\r\n")
          |> Enum.reverse()

        {Enum.reverse(lines), last_line}
    end)
  end
end
