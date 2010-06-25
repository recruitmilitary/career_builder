module CareerBuilder

  class Client

    RESUME_SERVICE_ENDPOINT_URL = 'http://ws.careerbuilder.com/resumes/resumes.asmx'

    attr_reader :session_token

    def initialize(email, password)
      @email, @password = email, password
    end

    def authenticate
      response = perform_request("BeginSessionV2", "<Email>#{@email}</Email><Password>#{@password}</Password>")
      packet = Nokogiri::XML(parse_terrible_response(response))

      if session_token = packet.search("//SessionToken")
        session_token_text = session_token.text
        unless session_token_text == "Invalid"
          @session_token = session_token.text
        end
      end
    end

    def authenticated?
      !session_token.nil?
    end

    # List of valid options available at:
    # http://ws.careerbuilder.com/resumes/resumes.asmx/V2_AdvancedResumeSearch_ValidFields
    #
    VALID_OPTIONS_FOR_ADVANCED_RESUME_SEARCH = [:keywords, :search_pattern,
                                       :job_categories, :city, :state, :zip_code, :country, :search_radius_in_miles, :relocation_filter, :freshness_in_days, :employment_type, :minimum_experience, :minimum_travel_requirement, :minimum_degree, :compensation_type, :minimum_salary, :maximum_salary, :exclude_resumes_with_no_salary, :languages_spoken, :currently_employed, :management_experience, :minimum_employees_managed, :maximum_commute, :security_clearance, :work_status, :exclude_ivr_resumes, :order_by, :page_number, :rows_per_page, :cust_acct_code, :custom_xml, :military_experience, :niche_inclusion, :lemmatize, :job_title, :company, :school, :rsadid, :cb_minimum_experience, :cb_maximum_experience].freeze

    def valid_options_for_advanced_resume_search?(options)
      (options.keys - VALID_OPTIONS_FOR_ADVANCED_RESUME_SEARCH).empty?
    end

    def advanced_resume_search(options = {})
      raise ArgumentError unless valid_options_for_advanced_resume_search?(options)
      require_authentication
      options.merge!(:session_token => session_token)
      response = perform_request("V2_AdvancedResumeSearch", transform_options_to_xml(options))

      xml_from_response = parse_terrible_response(response)
      ResumeSearchResult.parse(xml_from_response)
    end

    VALID_OPTIONS_FOR_GET_RESUME = [:resume_id, :cust_acct_code, :get_word_doc_if_available]

    def valid_options_for_get_resume?(options)
      (options.keys - VALID_OPTIONS_FOR_GET_RESUME).empty?
    end

    def get_resume(options = {})
      raise ArgumentError unless valid_options_for_get_resume?(options)
      require_authentication
      options.merge!(:session_token => session_token)
      response = perform_request("V2_GetResume", transform_options_to_xml(options))

      xml_from_response = parse_terrible_response(response)
      Resume.parse(xml_from_response, :single => true)
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

    def require_authentication
      if !authenticated?
        unless authenticate
          raise InvalidCredentials
        end
      end
    end

  end

end
