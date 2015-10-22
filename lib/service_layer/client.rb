require 'faraday'
require 'json'
require 'uri'

module ServiceLayer
  class Client
    class NotFound < StandardError; end
    class Unprocessable < StandardError; end

    autoload :CLI, 'service_layer/client/cli'

    def connection
      @connection ||= Faraday.new(url: ServiceLayer.config.app_uri)
    end

    def index
      response = connection.get

      JSON.parse(response.body, symbolize_names: true)
    end

    def show(id)
      response = connection.get(id)
      body     = JSON.parse(response.body, symbolize_names: true)

      fail NotFound if response.status == 404

      body
    end

    def create(options)
      response = connection.post { |request| request.body = options.to_json }
      body     = JSON.parse(response.body, symbolize_names: true)

      fail Unprocessable if response.status == 422

      body
    end

    def update(id, options)
      response = connection.put(id) { |request| request.body = options.to_json }
      body     = JSON.parse(response.body, symbolize_names: true)

      fail NotFound if response.status == 404
      fail Unprocessable if response.status == 422

      body
    end

    def delete(id)
      response = connection.delete(id)
      body     = JSON.parse(response.body, symbolize_names: true)

      fail NotFOund if response.status == 404

      body
    end

  end
end
