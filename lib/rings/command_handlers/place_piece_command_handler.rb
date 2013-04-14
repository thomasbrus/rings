require 'rings/command_handling'
require 'rings/command_handler'

module Rings
  module CommandHandlers
    class PlacePieceCommandHandler < CommandHandler
      include CommandHandling
      has_arguments type: :string, color: :string, x: :integer, y: :integer
      
      def initialize(session, *args)
        super session
        parse_arguments args
      end

      def self.command
        'place_piece'
      end      

      def handle_command
        if @session.place_piece
          args = [arguments(:type), arguments(:color), arguments(:x), arguments(:y)]

          begin
            # Handle when not in turn
            client_socket.game.place_piece *args
          rescue ArgumentError => e
            raise CommandError, e.message
          end

          notify_all_players :place_ring, *args

          if client_socket.game.over?
            @session.end_game!
            # client_socket.game.game_over!
            notify_all_players :game_over, *winners.map(&:nickname)
          end
        end
      end

      private

      def notify_all_players command, args
        client_socket.game.each_player do |player|
          player.send_command command, *args
        end
      end
    end
  end
end
