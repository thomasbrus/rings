require 'socket'
require 'forwardable'

module Rings
  class Server < TCPServer
    attr_reader :port
    
    extend Forwardable
    def_delegators :STDOUT, :puts
    
    class NickNameTakenError < RuntimeError; end
    
    def initialize port 
      @port = port
      @sockets = []
      super @port
    end

    def with_connected_socket client_socket, &block
      raise NickNameTakenError, "Name already taken" if nickname_taken? client_socket.name
      @sockets.push client_socket
      yield
      @sockets.delete client_socket
      client_socket.close
    end

    def nickname_taken? name
      @sockets.map(&:name).include? name
    end

    def chat_supported?
      true
    end

    def challenge_supported?
      true
    end

  end
end