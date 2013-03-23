module Rings
  module Commands
    class GreetCommand
      def initialize(client_handler, name, chat_supported, challenge_supported)
        @client_handler = client_handler
        @name = name
        @chat_supported = chat_supported
        @challenge_supported = challenge_supported
      end

      def process!
        @client.puts "greet #{@server.chat_supported?} #{@server.chat_supported?}"
      end
    end
  end
end