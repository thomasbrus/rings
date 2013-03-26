require 'rings/command_handling'
require 'rings/command_handler'
require 'rings/waiting_queue'

module Rings
  module CommandHandlers
    class JoinCommandHandler < CommandHandler
      extend CommandHandling
      has_arguments number_of_players: :number

      def self.command
        'join'
      end      

      def handle_command
        unless number_of_players.between? Game::MIN_PLAYERS, Game::MAX_PLAYERS # TODO: Use Rules::MIN/MAX_PLAYERS
          client.puts %q[error "Number of players is invalid."] and return
        end

        # Get the queue for a game of #number_of_players players
        waiting_queue = WaitingQueue.instance_for number_of_players

        # Add the client to the queue
        waiting_queue.enqueue client
        client.puts "Now waiting to start a game with #{number_of_players} players."

        if waiting_queue.ready?
          waiting_queue.each do |player|
            # Notify each player that the game has begun
            player.puts "The game has begun ..."
            # Remove the player from all queues
            WaitingQueue.withdraw player
          end
        end
      end
    end
  end
end