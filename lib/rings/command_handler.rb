require 'forwardable'

module Rings
  class CommandHandler
    extend Forwardable
    def_delegators :@client_handler, :server, :client_socket

    def initialize(client_handler)
      @client_handler = client_handler
    end

    def self.command
      raise NotImplementedError, "Sub class must implemented this method"
    end

    private

    def handle_command
      raise NotImplementedError, "Sub class must implemented this method"
    end
  end
end