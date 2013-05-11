require 'uri'

module Rings
  module CommandHandling
    ARGUMENT_TYPES = [:integer, :boolean, :string].freeze
    ARGUMENT_TYPE_REGEXES = { integer: /[0-9]+/, boolean: /0|1/, string: /[^\s]+/ }
    ARGUMENT_TYPE_METHODS = {
      integer: :to_i,
      boolean: ->(value) { value.to_i == 1 },
      string: ->(value) { URI.decode(value) }
    }

    private_constant :ARGUMENT_TYPES, :ARGUMENT_TYPE_REGEXES, :ARGUMENT_TYPE_METHODS

    class CommandError < RuntimeError; end

    def self.included(base)
      base.extend(ClassMethods)
    end

    module ClassMethods
      def has_arguments(options)
        if options.any? { |key, format_type| !ARGUMENT_TYPES.include?(format_type) }
          raise CommandError, "Invalid argument options: #{options.inspect}"
        end

        define_singleton_method(:argument_options) { options }
        send :include, InstanceMethods
      end
    end

    module InstanceMethods
      def arguments(key)
        (@parsed_arguments || {})[key]
      end

      def parse_arguments(arguments)
        options = self.class.argument_options

        unless arguments.count == options.count
          raise CommandError, "Wrong number of arguments given " +
            " (#{arguments.count} for #{options.count})."
        end

        parsed_values = options.values.zip(options.keys, arguments).map do |type, key, value|
          match_data = value.match(ARGUMENT_TYPE_REGEXES[type])

          if (match_data.nil? || value != match_data.to_s)
            raise CommandError, "Could not parse as #{type}: #{value}"
          end

          ARGUMENT_TYPE_METHODS[type].to_proc.(value)
        end

        @parsed_arguments = Hash[*options.keys.zip(parsed_values).flatten]
      end
    end
  end
end
