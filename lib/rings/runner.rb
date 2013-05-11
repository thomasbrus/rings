require 'rings'
require 'rings/session'
require 'rings/acts/client'
require 'rings/acts/player'

module Rings
  module Runner

    def self.run(server)
      server.logger.info "Rings Server started on port #{server.port}"

      # Exit gracefully using ctrl-c
      trap('INT') { Kernel.exit(0) }

      loop do
        Thread.abort_on_exception = true
        Thread.start(server.accept) do |client_socket|
          # TODO: Use DelegateClass (http://pivotallabs.com/delegateclass-rocks-my-world/)
          # Like so: Client.new(client_socket)
          client_socket.class.send :include, Rings::Acts::Client
          client_socket.class.send :include, Rings::Acts::Player
          client_socket.class.send :acts_as_client
          client_socket.class.send :acts_as_player
          server.logger.info "#{client_socket.inspect} connected with ip #{client_socket.peeraddr.last}"
          Rings::Session.new(server, client_socket)
        end
      end
    end

  end
end