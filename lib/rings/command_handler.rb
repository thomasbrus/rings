require 'forwardable'

module Rings
  class CommandHandler
    extend Forwardable
    def_delegators :@client_handler, :server, :client

    def initialize(client_handler, *args)
      @client_handler = client_handler
      parse_arguments *args
      handle_command
    end

    def self.command
      raise NotImplementedError, "Sub class must implemented this method"
    end

    def handle_command
      raise NotImplementedError, "Sub class must implemented this method"
    end

    private

    def parse_arguments(*args)
      if args.count < self.argument_options.keys.count
        raise ArgumentError, "Too few arguments given. " +
          "Expected #{self.argument_options.keys.count} argument(s) " +
          "(" + self.argument_options.keys.map(&:inspect).join(', ') + "), " +
          "but got #{args.count}."
      end

      args.zip(self.argument_options.keys, self.argument_options.values).each do |value, key, regex|
        if value.match(regex).nil? or $~.to_s != value
          raise ArgumentError, "Could not parse argument #{key.to_s.inspect}: #{value.inspect}"
        else
          instance_variable_set "@#{key}".to_sym, value
        end
      end
    end
  end
end