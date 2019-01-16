module RaygunRubyClient
  class Client
    module Session
      DEFAULT_SESSIONS_ENDPOINT = 'https://api.raygun.com/api/v1/pulse/sessions'.freeze

      def sessions(options={})
        sessions = []

        response = sessions_connection(options).get

        if response.success?
          parsed_response = JSON.parse(response)
          return [] unless parsed_response['totalSessions'] > 0

          sessions = sessions.concat(parsed_response['sessions'])

          while !parsed_response['links']['next'].nil?
            response = sessions_connection(url: parsed_response['links']['next']).get
            parsed_response = JSON.parse(response)
            sessions = sessions.concat(parsed_response['sessions'])
          end
        else
          handle_error(response)
        end

        sessions
      end

      def session(external_id)
        if external_id.nil?
          raise MissingParameterError.new([:id], "#{DEFAULT_SESSIONS_ENDPOINT}?id=<missing>")
        end
        response = sessions_connection(id: external_id).get

        if response.success?
          JSON.parse(response)['session']
        else
          handle_error(response)
        end
      end

      private

      def sessions_connection(options)
        url = options.fetch(:url) { DEFAULT_SESSIONS_ENDPOINT }
        Faraday.new(url: url) do |faraday|
          faraday.headers = headers
          faraday.params = options.reject { |k, v| !v.nil? }
        end
      end

      def headers
        {
          'X-SESSIONKEY' => self.session_key,
          'Content-Type'  => 'application/json'
        }
      end
    end
  end
end
