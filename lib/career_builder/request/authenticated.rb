module CareerBuilder

  class Request::Authenticated < Request

    def perform
      super
      require_authentication
      options.merge!(:session_token => session_token) unless options.has_key?(:session_token)
    end

    private

    def require_authentication
      if !client.authenticated?
        unless client.authenticate
          raise InvalidCredentials
        end
      end
    end

  end

end
