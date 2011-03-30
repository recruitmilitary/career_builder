module CareerBuilder
  class Client
    module Authentication

      def session_token
        @session_token
      end

      def authenticate
        response = request("BeginSessionV2", 'Email' => email, 'Password' => password)

        packet = Nokogiri::XML(response)

        if session_token = packet.search("//SessionToken")
          session_token_text = session_token.text
          if session_token_text == "Invalid"
            @session_token = nil
          else
            @session_token = session_token_text
          end
        end
      end

      def authenticated?
        !session_token.nil?
      end

    end
  end
end
