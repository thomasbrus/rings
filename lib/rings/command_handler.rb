require 'forwardable'

module Rings
  class CommandHandler
    extend Forwardable
    def_delegators :@session, :server, :client_socket

    def initialize session
      @session = session
    end

    def self.command
      raise NotImplementedError, "Sub class must implemented this method"
    end

    def handle_command
      raise NotImplementedError, "Sub class must implemented this method"
    end
  end
end