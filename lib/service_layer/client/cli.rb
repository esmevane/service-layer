require 'thor'

module ServiceLayer
  class Client
    # Example of a CLI interface which uses the ServiceLayer client.  Overall
    # many of these methods contain either multi-stage logic, exception handling
    # or both.  The CLI should mostly be a declaration of how the client space
    # of the tool-kit interfaces the user with their options and then routes
    # the user to the correct API endpoints.
    #
    # As shown in the Api and Client classes, this class ought to be simply
    # empty boilerplate which is filled in by the gem designer.
    #
    # The ideal here is that these methods will be tailored to describe a given
    # service domain, and not retain generic words like "index" or "show".
    #
    class CLI < Thor
      include Messaging

      namespace :client

      desc "index", "View all resources"
      def index
        response = client.index
        info response.to_json
      rescue Faraday::ConnectionFailed
        warning "No running service found"
      end

      desc "show ID", "View a resource"
      def show(id)
        response = client.show(id)
        info response.to_json
      rescue Client::NotFound
        warning "No resource for that ID found"
      rescue Faraday::ConnectionFailed
        warning "No running service found"
      end

      desc "create OPTIONS", "Create a resource"
      def create(options)
        response = client.create(options)
        info response.to_json
      rescue Client::Unprocessable
        warning "Options given unprocessable"
      rescue Faraday::ConnectionFailed
        warning "No running service found"
      end

      desc "update ID OPTIONS", "Update a resource"
      def update(id, options)
        response = client.update(id, options)
        info response.to_json
      rescue Client::NotFound
        warning "No resource for that ID found"
      rescue Client::Unprocessable
        warning "Options given unprocessable"
      rescue Faraday::ConnectionFailed
        warning "No running service found"
      end

      desc "delete ID", "Delete a resource"
      def delete(id)
        response = client.delete(id)
        info response.to_json
      rescue Client::NotFound
        warning "No resource for that ID found"
      rescue Faraday::ConnectionFailed
        warning "No running service found"
      end

      private

      def client
        @client ||= Client.new
      end

    end
  end
end
