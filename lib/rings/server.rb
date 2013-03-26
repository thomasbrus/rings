require 'socket'

module Rings
  class Server < TCPServer
    attr_reader :port
    
    class NameTakenError < RuntimeError; end
    
    def initialize port 
      @port = port
      @sockets = []
      super @port
    end

    def with_connected_socket client, &block
      raise NameTakenError, "Name already taken" if name_taken? client.name
      @sockets.push client
      yield
      @sockets.delete client
    end

    def name_taken? name
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