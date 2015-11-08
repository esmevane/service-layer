require 'grape'
require 'forwardable'

module ServiceLayer
  class Api < Grape::API
    module Authentication
      class InterfaceError < StandardError; end

      class Authenticator

        HELPER_METHODS = %i(
          active_token?
          authenticate!
          current_key
          no_read_only_keys!
        )

        BAD_REQUEST    = { message: ::I18n.t('http.400'), code: 400 }
        INACTIVE_TOKEN = { message: ::I18n.t('http.401.inactive'), code: 401 }
        UNPRIVILEGED   = { message: ::I18n.t('http.401.privilege'), code: 401 }

        def self.helper_methods
          HELPER_METHODS
        end

        attr_reader :api, :params, :token, :strategy

        def initialize(api: , params: , strategy: )
          @api      = api
          @params   = params
          @token    = params.token
          @strategy = strategy
        end

        def active_token?
          current_key.present?
        end

        def authenticate!
          if token.blank?
            api.error! BAD_REQUEST, BAD_REQUEST.fetch(:code)
          elsif !active_token?
            api.error! INACTIVE_TOKEN, INACTIVE_TOKEN.fetch(:code)
          end
        end

        def current_key
          @current_key ||= strategy.call(token)
        end

        def no_read_only_keys!
          if current_key.consumer?
            api.error!(UNPRIVILEGED, UNPRIVILEGED.fetch(:code))
          end
        rescue NoMethodError, KeyError
          api.error! BAD_REQUEST, BAD_REQUEST.fetch(:code)
        end

      end

      extend Forwardable

      def self.included(base)
        required_interfaces = %i(params error!)
        base_interfaces     = base.instance_methods(false)
        viable_interfaces   = base_interfaces & required_interfaces

        fail InterfaceError unless viable_interfaces == required_interfaces
      end

      def_delegators :authenticator, *Authenticator.helper_methods

      def authenticator
        @authenticator ||= build_authenticator
      end

      private

      def build_authenticator
        strategy = ServiceLayer.config.token_strategy

        Authenticator.new(api: self, params: params, strategy: strategy)
      end

    end
  end
end
