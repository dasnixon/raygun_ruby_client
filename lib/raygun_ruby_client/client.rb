require 'faraday'
require 'raygun_ruby_client/version'

module RaygunRubyClient
  class Client
    require 'raygun_ruby_client/client/session'
    require 'raygun_ruby_client/client/authentication'
    require 'raygun_ruby_client/client/error_handler'

    include RaygunRubyClient::Client::Session
    include RaygunRubyClient::Client::Authentication
    include RaygunRubyClient::Client::ErrorHandler

    attr_accessor(*Configuration::VALID_OPTIONS_KEYS)

    def initialize(options = {})
      options = RaygunRubyClient.options.merge(options)
      Configuration::VALID_OPTIONS_KEYS.each do |key|
        send("#{key}=", options[key])
      end
    end
  end
end
