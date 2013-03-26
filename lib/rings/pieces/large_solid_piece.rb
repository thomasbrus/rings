require 'rings/piece'

module Rings
  module Pieces
    class LargeSolidPiece < Piece
      def solid?
        true
      end

      def size
        :large
      end
    end
  end
end
