module CareerBuilder
  class Client
    module GetResume

      VALID_OPTIONS = [:resume_id, :cust_acct_code, :get_word_doc_if_available].freeze

      def get_resume(options = {})
        unless (invalid_options = options.keys - VALID_OPTIONS).empty?
          raise ArgumentError, "Invalid options #{invalid_options}"
        end

        response = auth_request("V2_GetResume", options)

        if response =~ /ResumeID/ # valid response
          API::Resume.parse(response, :single => true)
        else
          raise OutOfCredits
        end
      end

    end
  end
end
