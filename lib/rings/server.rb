require 'socket'

module Rings
  class Server < TCPServer
    attr_reader :port

    def initialize port = 4567
      @port = port
      @sockets = []
      super ARGV.first ? ARGV.first.to_i : @port
    end

    def with_connected_socket client, &block
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