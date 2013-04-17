require 'rings/command_handling'
require 'rings/command_handler'
require 'rings/waiting_queue'
require 'rings/game'

module Rings
  module CommandHandlers
    class RequestGameCommandHandler < CommandHandler
      include CommandHandling
      has_arguments number_of_players: :integer

      def initialize(session, *args)
        super session
        parse_arguments args
      end

      def self.command
        'request_game'
      end      

      def handle_command
        @session.request_game!

        unless arguments(:number_of_players).between?(Game::MIN_PLAYERS, Game::MAX_PLAYERS)
          raise CommandError, "Wrong number of players"
        end

        waiting_queue = WaitingQueue.instance_for(arguments(:number_of_players))
        waiting_queue.enqueue @session

        if waiting_queue.ready? && waiting_queue.to_a.all?(&:start_game!)
          setup_game(waiting_queue.to_a.map(&:client_socket))
          waiting_queue.each { |session| WaitingQueue.withdraw(session) }
        end
        
      rescue StateMachine::InvalidTransition
        message = "Request game command not allowed. "
        message << "It's not allowed to request a game "
        message << "before joining the server or when already in game."
        client_socket.send_command(:error, message)
      end

      private

      def setup_game players
        x = [1,2,3].sample
        y = [1,2,3].sample
        game = Game.new x, y, players

        players.each do |player|
          player.game = game
          player.send_command start_game_command(players.count), *players.map(&:nickname), x, y
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
end