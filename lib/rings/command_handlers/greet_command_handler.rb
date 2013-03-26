require 'rings/command_handling'
require 'rings/command_handler'

module Rings
  module CommandHandlers
    class GreetCommandHandler < CommandHandler
      extend CommandHandling
      has_arguments name: :username, chat_supported?: :switch, challenge_supported?: :switch

      def self.command
        'greet'
      end

      def handle_command
        if server.name_taken? name
          client.puts %Q{error "Name '#{name}' is already taken."} and return
        end
        
        client.name = name
        client.chat_supported = chat_supported?
        client.challenge_supported = challenge_supported?

        client.puts "#{self.class.command} #{server.chat_supported? ? 1 : 0} #{server.challenge_supported? ? 1 : 0}"
      end
    end
  end
end