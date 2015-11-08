require 'grape'

module ServiceLayer
  # The actual hosting of ServiceLayer gems are exposed through this API, in
  # order to permit high distribution or composability.  Either erect this API
  # individually using the service CLI, mount it in Rails, Rack or Sinatra apps,
  # or simply observe how it handles internal functionality and use the bare
  # objects yourself.
  #
  class Api < Grape::API
    autoload :Authentication, 'service_layer/api/authentication'

    format :json

    get do
      []
    end

    post do
      {}
    end

    route_param(:id) do
      get do
        {}
      end

      patch do
        {}
      end

      delete do
        {}
      end
    end
  end
end
