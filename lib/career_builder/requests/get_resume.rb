module CareerBuilder

  module Requests

    class GetResume < Request::Authenticated

      VALID_OPTIONS = [:resume_id, :cust_acct_code, :get_word_doc_if_available].freeze

      def perform
        super
        response = perform_request("V2_GetResume", transform_options_to_xml(options))

        Resume.parse(response, :single => true)
      end

    end

  end

end
