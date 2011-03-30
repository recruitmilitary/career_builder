module CareerBuilder
  class Client
    module Request

      RESUME_SERVICE_ENDPOINT_URL = 'http://ws.careerbuilder.com/resumes/resumes.asmx'

      def auth_request(meth, options = {})
        if !authenticated? && !authenticate
          raise InvalidCredentials
        end

        options.merge!(:session_token => session_token)

        request meth, options
      end

      def request(meth, options = {})
        uri = URI.parse(RESUME_SERVICE_ENDPOINT_URL + "/#{meth}")

        options_as_xml = transform_options_to_xml(options)

        packet = { 'Packet' => "<Packet>#{options_as_xml}</Packet>" }

        response = Net::HTTP.post_form(uri, packet)

        parse_terrible_response(response)
      end

      def parse_terrible_response(response)
        xml_body = Nokogiri::XML(response.body) # not sure why I have to do it this way
        inner_xml = xml_body.children.first
        inner_xml.text
      end

      CUSTOM_KEY_TRANSFORMS = {
        :resume_id => "ResumeID",
        :account_did => "AccountDID"
      }

      def transform_key(key)
        if custom_transform = CUSTOM_KEY_TRANSFORMS[key]
          custom_transform
        else
          key.to_s.camelize
        end
      end

      def transform_key_value_to_tag(key, value)
        "<#{transform_key(key)}>#{value}</#{transform_key(key)}>"
      end

      def transform_options_to_xml(options)
        elements = []

        # let's make sure SessionToken is always at the top of the request
        if session_key = options.delete(:session_token)
          elements << transform_key_value_to_tag(:session_token, session_token)
        end

        options.sort_by { |k, v| k.to_s }.each do |key, value|
          elements << transform_key_value_to_tag(key, value)
        end

        elements.join
      end


    end
  end
end
