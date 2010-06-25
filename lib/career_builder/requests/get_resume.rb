module CareerBuilder

  module Requests

    class GetResume < Request

      VALID_OPTIONS = [:resume_id, :cust_acct_code, :get_word_doc_if_available]

      def perform
        validate_options
        require_authentication
        options.merge!(:session_token => session_token)
        response = perform_request("V2_GetResume", transform_options_to_xml(options))

        xml_from_response = parse_terrible_response(response)
        Resume.parse(xml_from_response, :single => true)
      end

    end

  end

end
