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

    protected
    
    def self.argument_options
      {}
    end

    private

    def parse_arguments(*args)
      options = self.class.argument_options
      if args.count < options.keys.count
        raise ArgumentError, "Too few arguments given."
      end
      
      options.values.zip(options.keys, args).each do |format, key, value|
        regex = case format
        when :number then /[0-9]+/
        when :switch then /0|1/
        when :username then /[a-z0-9_\-]+/i
        end

        if value.match(regex).nil? or value != $~.to_s
          raise ArgumentError, "Could not parse argument #{key.to_s.inspect}: #{value.inspect}"
        end

        method = case format
        when :number then :to_i
        when :switch then ->(arg) { arg == "1" }
        end

        value = method.to_proc.call value unless method.nil?
        self.class.send(:define_method, key) { value }
      end
    end
  end
end