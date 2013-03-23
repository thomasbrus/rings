require 'socket'

module Rings
  class Server < TCPServer
    attr_reader :port

    def initialize port = 4567
      @port = port
      super ARGV.first ? ARGV.first.to_i : @port
    end

    def chat_supported?
      true
    end

    def challenge_supported?
      true
    end
  end
end