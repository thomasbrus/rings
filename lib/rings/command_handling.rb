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
        options.each do |key, format_type|
          unless ARGUMENT_TYPES.include? format_type
            raise CommandError, "Invalid format type for argument " +
             "#{key.to_s.inspect}: "" #{format_type.inspect}"
          end
        end

        send :include, InstanceMethods
        define_singleton_method(:argument_options) { options }
      end
    end
  
    module InstanceMethods
      def parse_arguments(*args)
        options = self.class.argument_options
        
        unless args.count == options.count
          raise CommandError, sprintf("Wrong number of arguments (%d for %d)",
            args.count, options.count)
        end
        
        values = options.values.zip(options.keys, args).map do |type, key, value|
          if value.match(regex_by_argument_type(type)).nil? or value != $~.to_s
            raise CommandError, "Could not parse argument " +
              "(#{value} for #{key.inspect})"
          end
          method_by_argument_type(type).to_proc.call(value)
        end

        Hash[*options.keys.zip(values).flatten]
      end

      private

      def regex_by_argument_type type
        case type
        when :integer then /[0-9]+/
        when :boolean then /0|1/
        when :string then /[a-z0-9_\-]+/i
        end
      end

      def method_by_argument_type type
        case type
        when :integer then :to_i
        when :boolean then ->(arg) { arg == "1" }
        when :string then :to_s
        end
      end
    end
  end
end