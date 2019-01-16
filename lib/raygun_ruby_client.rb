require 'raygun_ruby_client/client'
require 'raygun_ruby_client/configuration'

module RaygunRubyClient
  extend Configuration
  class << self
    # Alias for Statuspageio::Client.new
    #
    # @return [Statuspageio::Client]
    def new(options = {})
      RaygunRubyClient::Client.new(options)
    end

    # Delegate to Gems::Client
    def method_missing(method, *args, &block)
      return super unless new.respond_to?(method)
      new.send(method, *args, &block)
    end

    def respond_to?(method_name, include_private = false)
      new.respond_to?(method_name, include_private) || super(method_name, include_private)
    end

    def respond_to_missing?(method_name, include_private = false)
      new.respond_to?(method_name, include_private) || super(method_name, include_private)
    end
  end
end
