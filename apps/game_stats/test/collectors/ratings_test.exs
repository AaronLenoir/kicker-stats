# defmodule GameStats.Collectors.RatingsTest do
#   use ExUnit.Case

#   import GameStats.Collectors.Ratings
#   alias GameStats.Model.Game
#   alias GameStats.Model.Team
#   alias GameStats.Model.Stats

#   test "collect updates rating to 400 + 16 for the winning players after one game" do
#     stats =
#       collect(Stats.new(), Game.parse("01/01/2023;Player A;Player B;10;0;Player C;Player D"))

#       assert stats.player["Player A"].rating == 400 + 16
#       assert stats.player["Player B"].rating == 400 + 16
#   end

#   test "collect updates rating to 400 - 16 for the losing players after one game" do
#     stats =
#       collect(Stats.new(), Game.parse("01/01/2023;Player A;Player B;10;0;Player C;Player D"))

#       assert stats.player["Player A"].rating == 400 + 16
#       assert stats.player["Player B"].rating == 400 + 16
#   end

#   test "collect updates rating to 400 + 16 for the winning team after one game" do
#     stats =
#       collect(Stats.new(), Game.parse("01/01/2023;Player A;Player B;10;0;Player C;Player D"))

#       assert stats.team["Player A - Player B"].rating == 400 + 16
#   end

#   test "collect updates rating to 400 - 16 for the losing team after one game" do
#     stats =
#       collect(Stats.new(), Game.parse("01/01/2023;Player A;Player B;10;0;Player C;Player D"))

#       assert stats.team["Player A - Player B"].rating == 400 - 16
#   end
# end
