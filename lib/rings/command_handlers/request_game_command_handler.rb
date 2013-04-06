require 'rings/command_handling'
require 'rings/command_handler'
require 'rings/waiting_queue'

module Rings
  module CommandHandlers
    class RequestGameCommandHandler < CommandHandler
      include CommandHandling
      has_arguments number_of_players: :integer

      def initialize(session, *args)
        super session
        parse_arguments *args
      end

      def self.command
        'request_game'
      end      

      def handle_command
        number_of_players = arguments(:number_of_players)

        unless number_of_players.between?(Game::MIN_PLAYERS, Game::MAX_PLAYERS)
          raise CommandError, "Wrong number of players"
        end

        if @session.request_game
          waiting_queue = add_to_queue(number_of_players)

          if waiting_queue.ready? && @session.start_game
            setup_game waiting_queue
          end
        end
      end

      private

      def add_to_waiting_queue capacity
        waiting_queue = WaitingQueue.instance_for capacity
        waiting_queue.enqueue client_socket
      end

      def setup_game
        game = Game.new waiting_queue.items
        client_socket.game = game
        x, y = game.place_starting_pieces

        waiting_queue.each do |player|
          WaitingQueue.withdraw player
          notify_player player, game, x, y          
        end
      end

      def notify_player player, game, x, y
        game.players.each do |player|
          player.send_command command, *game.players, x, y
        end
      end

      def start_game_command number_of_players
        case number_of_players
        when 2 then :start_two_player_game
        when 3 then :start_three_player_game
        when 4 then :start_four_player_game 
      end
    end
  end
end