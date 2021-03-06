require 'socket'
require 'forwardable'
require 'logger'
require 'logger/colors'

module Rings
  class Server < TCPServer
    attr_reader :port, :logger

    extend Forwardable

    def initialize(port = 4567, logger = Logger.new(STDOUT))
      super port
      @port = port
      @connected_clients = []
      @logger = logger
    end

    def with_connected_socket(client_socket, &block)
      @connected_clients.push client_socket
      block.call
    ensure
      @connected_clients.delete client_socket
    end

    def nickname_taken?(name)
      @connected_clients.map(&:nickname).include?(name)
    end

    def chat_supported?
      true
    end

    def challenge_supported?
      false
    end
  end
end
