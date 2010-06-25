module CareerBuilder

  module Requests

    class GetResume < Request

      VALID_OPTIONS_FOR_GET_RESUME = [:resume_id, :cust_acct_code, :get_word_doc_if_available]

      def valid_options_for_get_resume?(options)
        (options.keys - VALID_OPTIONS_FOR_GET_RESUME).empty?
      end

      def perform
        raise ArgumentError unless valid_options_for_get_resume?(options)
        require_authentication
        options.merge!(:session_token => session_token)
        response = perform_request("V2_GetResume", transform_options_to_xml(options))

        xml_from_response = parse_terrible_response(response)
        Resume.parse(xml_from_response, :single => true)
      end

    end

  end

end
