module Rings
  module CommandHandlers
    class JoinCommandHandler < CommandHandler
      extend CommandHandling
      has_arguments number_of_players: /2|3|4/

      def number_of_players
        @number_of_players.to_i
      end

      def self.command
        'join'
      end      

      def handle_command
        waiting_queue = WaitingQueue.new number_of_players

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