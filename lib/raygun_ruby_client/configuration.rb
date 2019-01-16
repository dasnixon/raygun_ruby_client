module RaygunRubyClient
  module Configuration
    # An array of valid keys in the options hash when configuring a {Gems::Client}
    VALID_OPTIONS_KEYS = [
      :client_id,
      :client_secret,
      :api_key,
      :session_key
    ].freeze

    attr_accessor(*VALID_OPTIONS_KEYS)

    # When this module is extended, set all configuration options to their default values
    def self.extended(base)
      base.reset
    end

    # Convenience method to allow configuration options to be set in a block
    def configure
      yield self
    end

    # Create a hash of options and their values
    def options
      options = {}
      VALID_OPTIONS_KEYS.each { |k| options[k] = send(k) }
      options
    end

    # Reset all configuration options to defaults
    def reset
      self.client_id     = nil
      self.client_secret = nil
      self.api_key       = nil
      self.session_key   = nil
      self
    end
  end
end
