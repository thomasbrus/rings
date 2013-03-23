module Rings
  module Pieces
    class SmallRingPiece < Piece
      def solid?
        false
      end

      def size
        :small
      end
    end
  end
end
