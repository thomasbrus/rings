module Rings
  module CommandHandling
    def has_arguments(options)
      define_method :argument_options do
        options
      end
    end
  end
end