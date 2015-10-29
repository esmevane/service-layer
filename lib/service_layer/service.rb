require 'daemons'
require 'rack'
require 'fileutils'

module ServiceLayer
  # `ServiceLayer::Service` gives an interface to start, stop, or otherwise
  # interact with the Grape API contained in `ServiceLayer::Api`.  This is
  # mainly intended for use with the service CLI, but exposes some elements of
  # its configuration through its initializer in order to permit some more
  # hands-on use.
  #
  class Service
    autoload :CLI, 'service_layer/service/cli'

    attr_reader :daemon, :dir, :name, :pidfile

    def initialize(options = {})
      @daemon  = options.fetch(:daemon, {})
      @dir     = options.fetch(:dir, "/tmp")
      @name    = options.fetch(:name, "service-layer")
      @pidfile = File.join(dir, "#{name}.pid")
    end

    def id
      File.read(pidfile).to_i if File.exist?(pidfile)
    end

    def running?
      !id.nil?
    end

    def start
      return if running?

      daemon = build_daemon
      app    = build_app

      ServiceLayer.ensure_connections { Daemons.daemonize(daemon) }
      Rack::Handler::Thin.run app, Host: '0.0.0.0', Port: '8080'
    end

    def stop
      return unless running?

      pid = File.read(pidfile).to_i
      begin
        Process.kill("TERM", pid)
      ensure
        FileUtils.rm(pidfile)
      end
    end

    private

    def build_app
      Rack::Builder.new do
        map('/') { run Api }
      end
    end

    # Add `ontop: true` as an additional option here in order to prevent it
    # from actually daemonizing.  It helps a ton with debugging.
    #
    def build_daemon
      base = {
        app_name: name,
        dir_mode: :normal,
        dir:      dir
      }.merge(daemon)

      base.tap do |hash|
        base[:ontop] = true if ServiceLayer.config.debug
      end

    end

  end
end
