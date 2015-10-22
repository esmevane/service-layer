require 'forwardable'

module ServiceLayer
  # The ServiceLayer logger, handled in its own class mainly for the purpose
  # of allowing the daemonized process to quickly and cleanly reinitialize its
  # connection to logfiles even after its process has been decoupled.
  #
  class Logger
    extend Forwardable

    attr_reader :logger

    def_delegators :logger, :info, :warn

    def initialize
      environment = ServiceLayer.config.app_env

      loginfo = [
        ServiceLayer.config.app_dir,
        ServiceLayer.config.log_dir,
        "service-layer-#{environment}.log"
      ]

      logpath = File.join(*loginfo)
      default = ::Logger.new(logpath, "daily")

      @logger = ServiceLayer.config.logger || default
    end
  end

end
