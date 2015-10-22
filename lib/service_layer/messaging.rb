require 'ansi'

module ServiceLayer
  # The goal of the Messaging module is to provide an easy to include internal
  # interface which will allow a ServiceLayer gem to dutifully log and provide
  # output of what it's up to and how it may be doing.
  #
  module Messaging
    def info(message)
      Message.new(message).info
    end

    def warning(message)
      Message.new(message).warn
    end

    private

    # Most of the logic for the Messaging module exists in this (not so)
    # private class.  This lets more complex handling of message logic enter
    # into the module gracefully, for example silence or logging level.
    #
    class Message
      attr_reader :env, :feedback, :message

      def initialize(message)
        @env      = ServiceLayer.config.app_env.to_s.ansi(:magenta)
        @feedback = ServiceLayer.config.verbose
        @message  = message
      end

      def warn
        Kernel.warn("--> [ #{env} ]: #{message.ansi(:red)}") if feedback
        ServiceLayer.logger.warn message
      end

      def info
        Kernel.puts("--> [ #{env} ]: #{message.ansi(:cyan)}") if feedback
        ServiceLayer.logger.info message
      end
    end

  end
end
