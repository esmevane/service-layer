require 'ostruct'
require 'yaml'
require 'uri'

module ServiceLayer
  module Configuration

    def configure
      yield(config) if block_given?
    end

    def config
      @config ||= OpenStruct.new
    end

  end
end
