module CareerBuilder

  module Requests

    class GetResume < Request::Authenticated

      VALID_OPTIONS = [:resume_id, :cust_acct_code, :get_word_doc_if_available].freeze

      def perform
        super
        response = perform_request("V2_GetResume", transform_options_to_xml(options))

        if response =~ /ResumeID/ # valid response
          API::Resume.parse(response, :single => true)
        else
          raise OutOfCredits
        end
      end

    end

  end

end
