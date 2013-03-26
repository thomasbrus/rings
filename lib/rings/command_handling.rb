module Rings
  module CommandHandling
    FORMAT_TYPES = [:number, :switch, :username].freeze
    private_constant :FORMAT_TYPES

    class InvalidFormatError < RuntimeError; end
    class ArgumentParseError < RuntimeError; end

    def self.included(base)
      base.extend(ClassMethods)
    end

    module ClassMethods
      def has_arguments(options)      
        options.each do |key, format_type|
          unless FORMAT_TYPES.include? format_type
            raise InvalidFormatError, "Invalid format type for argument " +
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
          raise ArgumentError, sprintf("Wrong number of arguments (%d for %d)",
            args.count, options.count)
        end
        
        values = options.values.zip(options.keys, args).map do |format_type, key, value|
          if value.match(regex_by_format_type(format_type)).nil? or value != $~.to_s
            raise ArgumentParseError, "Could not parse argument " +
              "#{key.to_s.inspect}: #{value.inspect}"
          end

          method = method_by_format_type format_type
          method.nil? ? value : method.to_proc.call(value)
        end

        Hash[*options.keys.zip(values).flatten]
      end

      private

      def regex_by_format_type format_type
        case format_type
        when :number then /[0-9]+/
        when :switch then /0|1/
        when :username then /[a-z0-9_\-]+/i
        end
      end

      def method_by_format_type format_type
        case format_type
        when :number then :to_i
        when :switch then ->(arg) { arg == "1" }
        end
      end
    end
  end
end