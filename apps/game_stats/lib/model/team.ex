defmodule GameStats.Model.Team do
  @doc """
  Information on a team
  """

  alias GameStats.Model.Team

  defstruct [
    :keeper,
    :striker,
    :score
  ]

  @type t :: %Team{}

  def get_name(%{keeper: keeper, striker: striker}), do: "#{keeper} - #{striker}"
end
