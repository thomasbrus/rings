require 'forwardable'
require 'state_machine/core'

module Rings
  class CommandHandler
    extend Forwardable
    def_delegators :@session, :server, :client_socket

    def initialize(session)
      @session = session
    end

    def self.command
      raise NotImplementedError, "Sub class must implement this method"
    end

    def handle_command
      raise NotImplementedError, "Sub class must implement this method"
    end
  end
end
