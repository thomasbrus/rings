module Rings
  module Pieces
    class LargeRingPiece < Piece
      def solid?
        false
      end

      def size
        :large
      end
    end
  end
end
