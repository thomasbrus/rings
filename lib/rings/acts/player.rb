require 'uri'

module Rings
  module Acts
    module Player
      def self.included(base)
        base.extend(ClassMethods)
      end

      module ClassMethods
        def acts_as_player
          include InstanceMethods
        end
      end

      module InstanceMethods
        attr_accessor :game, :arsenal

        def in_game?
          !game.nil?
        end

        def take_turn piece, x, y
          game.take_turn(self, piece, x, y)
        end

        def remove_piece_from_arsenal piece
          unless can_remove_piece_from_arsenal?(piece)
            raise ArgumentError, "Cannot remove this piece from the arsenal"
          end
          arsenal.delete_at(arsenal.index(piece))
        end

        def can_remove_piece_from_arsenal? piece
          arsenal.include?(piece)
        end
      end
    end
  end
end
