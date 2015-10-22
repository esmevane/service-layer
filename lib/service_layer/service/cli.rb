require 'thor'

module ServiceLayer
  class Service
    # The service CLI is a Thor runner that provides a friendly tool for
    # operating a ServiceLayer service.  This CLI logs output and outputs to
    # stdout and stderr for use in bash scripts or other shell operations.
    # For example, if you wanted to put together a script which would bootstrap
    # a ServiceLayer gem on startup, almost all functionality is provided here.
    #
    class CLI < Thor
      include Messaging

      namespace :service

      desc "stop", "Stop the service"
      def stop
        if service.running?
          id = service.id

          service.stop
          info "Service stopped, PID #{id}"
        else
          warning "No running service found"
        end
      end

      desc "start", "Start the service"
      def start
        if service.running?
          info "Service already running, PID #{service.id}"
        else
          info "Starting service"
          service.start
        end
      end

      desc "restart", "Restart the service (starts if not yet started)"
      def restart
        stop
        start
      end

      desc "id", "Return the process ID if it exists"
      def id
        if service.running?
          puts service.id
        else
          warning "No running service found"
        end
      end

      private

      def service
        @service ||= Service.new
      end

    end
  end
end
