module RaygunRubyClient
  class Client
    module Authentication
      DEFAULT_AUTHENTICATION_ENDPOINT = 'https://api.raygun.com/api/v1/pulse/authenticate'.freeze

      def authenticate!
        response = Faraday.get(url: DEFAULT_AUTHENTICATION_ENDPOINT, headers: headers)

        if response.success?
          self.session_key = JSON.parse(response)['sessionKey']
        else
          handle_error(response)
        end
      end

      private

      def headers
        {
          'Authorization' => "Basic #{base64_encoded_authorization}",
          'Content-Type'  => 'application/json'
        }
      end

      def base64_encoded_authorization
        Base64.encode64("#{self.client_id}:#{self.client_secret}")
      end
    end
  end
end
