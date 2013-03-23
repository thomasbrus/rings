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
        puts "Handling join command."
      end
    end
  end
end