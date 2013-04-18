require 'rings/command_handling'
require 'rings/command_handler'
require 'rings/waiting_queue'
require 'rings/game'

require 'state_machine/core'

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
        if @session.can_request_game?
          @session.request_game!

          unless arguments(:number_of_players).between?(Game::MIN_PLAYERS, Game::MAX_PLAYERS)
            raise CommandError, "Wrong number of players"
          end

          waiting_queue = WaitingQueue.instance_for(arguments(:number_of_players))
          waiting_queue.enqueue @session

          if waiting_queue.ready?
            sessions = waiting_queue.to_a
            sessions.each(&:start_game)
            setup_game(sessions.map(&:client_socket))
            sessions.each { |session| WaitingQueue.withdraw(session) }
          end
        else
          message = "Request game command not allowed. "
          message << "It's not allowed to request a game "
          message << "before joining the server or when already in game."
          client_socket.send_command(:error, message)
        end
      end

      private

      def setup_game players
        x = [1,2,3].sample
        y = [1,2,3].sample
        game = GamesFactory.create(x, y, players)

        players.each do |player|
          player.game = game
          nicknames = players.map(&:nickname)
          colors = *Piece::ALLOWED_COLORS
          player.send_command start_game_command(players.count), *nicknames, x, y, *colors
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