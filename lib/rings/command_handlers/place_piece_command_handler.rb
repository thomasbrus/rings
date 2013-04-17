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
        @session.place_piece!

        piece = PiecesFactory.create(arguments(:type), arguments(:color))
        client_socket.take_turn(piece, arguments(:x), arguments(:y))
        
        args = [arguments(:type), arguments(:color), arguments(:x), arguments(:y)]
        notify_all_players(:place_piece, args)

        if client_socket.game.over?
          @session.end_game!
          notify_all_players(:game_over, *client_socket.game.winners.map(&:nickname))
        end

      rescue StateMachine::InvalidTransition        
        message = "Place piece command not allowed. "
        message << "It's only allowed to place pieces while in game."
        client_socket.send_command(:error, message)
      rescue ArgumentError => e
        raise CommandError, e.message
      end

      private

      def notify_all_players command, args
        client_socket.game.each_player do |player|
          player.send_command(command, *args)
        end
      end
    end
  end
end
