require "service_layer/version"

module ServiceLayer
  autoload :Api,           'service_layer/api'
  autoload :CLI,           'service_layer/cli'
  autoload :Client,        'service_layer/client'
  autoload :Configuration, 'service_layer/configuration'
  autoload :Logger,        'service_layer/logger'
  autoload :Messaging,     'service_layer/messaging'
  autoload :Service,       'service_layer/service'

  extend Configuration

  configure do |config|
    config.app_uri = ENV.fetch("APP_URI", "http://localhost:8080")
    config.app_env = ENV.fetch("APP_ENV", "development")
    config.app_dir = ENV.fetch("APP_DIR", nil) || Dir.pwd
    config.verbose = ENV.fetch("APP_VERBOSE", true)
    config.debug   = ENV.fetch("APP_DEBUG", false)

    config.log_dir = ENV.fetch("LOG_DIR") do
      Dir.mkdir('log') unless Dir.exist?('log')

      'log'
    end
  end

  # Any time a service is launched in daemonized mode, it drops all file or
  # persistence connections, which can be hell for logging or debugging.  Any
  # connection your service requires for operation should be rebuilt through
  # this method after the yield statement.
  #
  def self.ensure_connections
    yield if block_given?

    # Put reconnection code here.
    #
    @logger = Logger.new
  end

  def self.logger
    @logger ||= Logger.new
  end

end
