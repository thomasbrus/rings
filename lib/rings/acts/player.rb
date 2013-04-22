require 'uri'

module Rings
  module Acts
    module Player
      def self.included(base)
        base.extend(ClassMethods)
      end

      module ClassMethods
        def acts_as_player
          send :include, InstanceMethods
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
          index = arsenal.index(piece)
          
          if index.nil?
            message = "Cannot remove this piece from the arsenal"
            raise ArgumentError, message
          end

          arsenal.delete_at(index)
        end

        def can_remove_piece_from_arsenal? piece
          arsenal.include?(piece)
        end
      end
    end
  end
end
