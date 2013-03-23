module Rings
  module ClientMethods
    def self.included(base)
      attr_accessor :name
      attr_writer :chat_supported, :challenge_supported

      def chat_supported?
        @chat_supported
      end

      def challenge_supported?
        @challenge_supported
      end
    end
  end
end