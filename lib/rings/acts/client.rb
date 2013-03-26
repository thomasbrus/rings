module Rings
  module Acts
    module Client
      def acts_as_client
        send :include, InstanceMethods
      end

      module InstanceMethods
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
end