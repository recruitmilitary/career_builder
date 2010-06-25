module CareerBuilder

  class Request

    RESUME_SERVICE_ENDPOINT_URL = 'http://ws.careerbuilder.com/resumes/resumes.asmx'

    attr_reader :options, :client

    def initialize(client, options = {})
      @client, @options = client, options
    end

    private

    def require_authentication
      if !client.authenticated?
        unless client.authenticate
          raise InvalidCredentials
        end
      end
    end

    def session_token
      client.session_token
    end

    def parse_terrible_response(response)
      xml_body = Nokogiri::XML(response.body) # not sure why I have to do it this way
      inner_xml = xml_body.children.first
      inner_xml.text
    end

    CUSTOM_KEY_TRANSFORMS = {
      :resume_id => "ResumeID"
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

      options.each do |key, value|
        elements << transform_key_value_to_tag(key, value)
      end

      elements.join
    end

    def perform_request(method, packet_contents)
      Net::HTTP.post_form(URI.parse(RESUME_SERVICE_ENDPOINT_URL + "/#{method}"), 'Packet' => "<Packet>#{packet_contents}</Packet>")
    end

  end

end
