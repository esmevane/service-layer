require 'grape'

module ServiceLayer
  # The actual hosting of ServiceLayer gems are exposed through this API, in
  # order to permit high distribution or composability.  Either erect this API
  # individually using the service CLI, mount it in Rails, Rack or Sinatra apps,
  # or simply observe how it handles internal functionality and use the bare
  # objects yourself.
  #
  class Api < Grape::API
    format :json

    get do
      []
    end

    get(":id") do
      {}
    end

    post do
      {}
    end

    put(":id") do
      {}
    end

    delete(":id") do
      {}
    end
  end
end
