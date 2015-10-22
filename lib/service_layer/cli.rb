require 'thor'

module ServiceLayer
  # A top-level interaction suite which bundles together all other CLIs for
  # ServiceLayer gems into namespaced subcommands.
  #
  class CLI < Thor
    desc "service", "Start, stop and manage a ServiceLayer service"
    subcommand "service", ServiceLayer::Service::CLI

    desc "client", "Interact with a ServiceLayer service using a remote CLI"
    subcommand "client", ServiceLayer::Client::CLI
  end
end
