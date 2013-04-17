require 'socket'
require 'forwardable'

module Rings
  class Server < TCPServer
    attr_reader :port
    
    extend Forwardable
    def_delegators :STDOUT, :puts
        
    def initialize port
      super port
      @port = port
      @connected_clients = []
    end

    def with_connected_socket client_socket, &block
      @connected_clients.push client_socket
      yield
      @connected_clients.delete client_socket
    end

    def nickname_taken? name
      @connected_clients.map(&:nickname).include? name
    end

    def chat_supported?
      true
    end

    def challenge_supported?
      false
    end

  end
end