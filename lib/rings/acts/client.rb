module Rings
  module Acts
    module Client
      def self.included(base)
        base.extend(ClassMethods)
      end

      module ClassMethods
        def acts_as_client
          send :include, InstanceMethods
        end
      end

      module InstanceMethods
        attr_accessor :nickname, :game
        attr_writer :chat_supported, :challenge_supported

        def chat_supported?
          @chat_supported
        end

        def challenge_supported?
          @challenge_supported
        end

        def in_game?
          !game.nil?
        end
      end
    end
  end
end