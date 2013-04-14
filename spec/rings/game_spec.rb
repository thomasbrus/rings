# require 'spec_helper'
# require 'rings/game'

# describe Game do
#   let (:game) { Game.new [] }

#   describe "#place_piece" do
    
#   end

#   describe "#place_starting_pieces" do
#     it "chooses a random field within a valid range" do
#       Board.any_instance.should_receive(:place_starting_pieces).once do |x, y|
#         x.should be_between 1, 3
#         y.should be_between 1, 3
#       end
#       game.place_starting_pieces      
#     end

#     it "returns the x and y coordinates of the starting pieces" do
#       x, y = game.place_starting_pieces
#       x.should be_between 1, 3
#       y.should be_between 1, 3
#     end


#   end



# end