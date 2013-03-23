module Rings
  module ClientMethods
    def self.included(base)
      attr_accessor :name
    end
  end
end