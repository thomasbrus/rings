require 'rings/piece'

module Rings
  module Pieces
    class ExtraSmallSolidPiece < Piece
      def solid?
        true
      end

      def size
        :extra_small
      end
    end
  end
end
