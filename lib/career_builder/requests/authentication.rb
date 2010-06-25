module CareerBuilder

  module Requests

    class Authentication < Request

      def perform
        response = perform_request("BeginSessionV2", "<Email>#{options[:email]}</Email><Password>#{options[:password]}</Password>")
        packet = Nokogiri::XML(parse_terrible_response(response))

        if session_token = packet.search("//SessionToken")
          session_token_text = session_token.text
          if session_token_text == "Invalid"
            return nil
          else
            return session_token_text
          end
        end
      end

    end

  end

end
