require 'uri'

module Rings
  module CommandHandling
    ARGUMENT_TYPES = [:integer, :boolean, :string].freeze
    private_constant :ARGUMENT_TYPES

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

      def parse_arguments arguments
        options = self.class.argument_options
        
        unless arguments.count == options.count
          given = arguments.count
          expected = options.count
          raise CommandError, "Wrong number of arguments given (#{given} for #{expected})."
        end
        
        parsed_values = options.values.zip(options.keys, arguments).map do |type, key, value|
          if (match_data = value.match(regex_by_argument_type(type))).nil? || value != match_data.to_s
            raise CommandError, "Could not parse as #{type}: #{value}"
          end

          method_by_argument_type(type).to_proc.(value)
        end

        @parsed_arguments = Hash[*options.keys.zip(parsed_values).flatten]
      end

      private

      def regex_by_argument_type type
        case type
        when :integer then /[0-9]+/
        when :boolean then /0|1/
        when :string then /[^\s]+/
        end
      end

      def method_by_argument_type type
        case type
        when :integer then :to_i
        when :boolean then ->(value) { value.to_i == 1 }
        when :string then ->(value) { URI.decode value }
        end
      end
    end
  end
end
