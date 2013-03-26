require 'rings/piece'

module Rings
  module Pieces
    class MediumRingPiece < Piece
      def solid?
        false
      end

      def size
        :medium
      end
    end
  end
end
