module Rings
  module CommandHandlers
    class GreetCommandHandler < CommandHandler
      extend CommandHandling
      has_arguments name: /[a-z0-9\-_]+/i, chat_supported: /0|1/, challenge_supported: /0|1/

      def name
        @name
      end

      def chat_supported?
        @chat_supported == "1"
      end

      def challenge_supported?
        @challenge_supported == "1"
      end

      def self.command
        'greet'
      end

      def handle_command
        if server.name_taken? name
          client.puts %Q{error "Name '#{name}' is already taken."}
        else
          client.name = name
          client.chat_supported = chat_supported?
          client.challenge_supported = challenge_supported?
          client.puts "#{self.class.command} #{server.chat_supported? ? 1 : 0} #{server.challenge_supported? ? 1 : 0}"
        end
      end
    end
  end
end