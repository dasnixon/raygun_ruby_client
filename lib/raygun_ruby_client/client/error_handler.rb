module RaygunRubyClient
  module ErrorHandler
    class BadRequestError < StandardError
      def message
        'Bad request. Check all required fields have been specified and values are in the expected format.'
      end
    end
    class RateLimitedError < StandardError
      def message
        'Rate limited. Too many requests within the specified period of time.'
      end
    end
    class UnauthorizedError < StandardError
      def message
        'Unauthorized. API key or Authorization headers not supplied, or invalid.'
      end
    end
    class ServerError < StandardError
      def message
        'Server error. Contact Raygun for further information.'
      end
    end
    class MissingParameterError < StandardError
      attr_reader :missing_parameters, :endpoint

      def initialize(missing_parameters)
        @missing_parameters = missing_parameters
        @endpoint = endpoint
      end

      def message
        "Missing #{parameter_pluralization} #{missing_parameters.join(', ')} for #{endpoint}"
      end

      private

      def parameter_pluralization
        "parameter#{'s' if self.missing_parameters.length > 1}".strip
      end
    end

    def handle_error(response)
      case response.status
      when 400
        raise BadRequestError
      when 401
        raise UnauthorizedError
      when 429
        raise RateLimitedError
      when 500
        raise ServerError
      end
    end
  end
end
