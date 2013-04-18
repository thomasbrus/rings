require 'uri'

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
        attr_accessor :nickname
        attr_writer :chat_supported, :challenge_supported

        def chat_supported?
          @chat_supported
        end

        def challenge_supported?
          @challenge_supported
        end
        
        def send_command command, *args
          encoded_args = args.map { |arg| URI.encode(arg.to_s) }
          puts [command, *encoded_args].join(' ')
        end
      end
    end
  end
end