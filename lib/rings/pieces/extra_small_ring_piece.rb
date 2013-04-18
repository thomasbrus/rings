require 'rings/piece'

module Rings
  module Pieces
    class ExtraSmallRingPiece < Piece
      def solid?
        false
      end

      def size
        :extra_small
      end
    end
  end
end
