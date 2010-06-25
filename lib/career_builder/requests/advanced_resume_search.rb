module CareerBuilder

  module Requests

    class AdvancedResumeSearch < Request

      # List of valid options available at:
      # http://ws.careerbuilder.com/resumes/resumes.asmx/V2_AdvancedResumeSearch_ValidFields
      #
      VALID_OPTIONS_FOR_ADVANCED_RESUME_SEARCH = [:keywords, :search_pattern,
                                                  :job_categories, :city, :state, :zip_code, :country, :search_radius_in_miles, :relocation_filter, :freshness_in_days, :employment_type, :minimum_experience, :minimum_travel_requirement, :minimum_degree, :compensation_type, :minimum_salary, :maximum_salary, :exclude_resumes_with_no_salary, :languages_spoken, :currently_employed, :management_experience, :minimum_employees_managed, :maximum_commute, :security_clearance, :work_status, :exclude_ivr_resumes, :order_by, :page_number, :rows_per_page, :cust_acct_code, :custom_xml, :military_experience, :niche_inclusion, :lemmatize, :job_title, :company, :school, :rsadid, :cb_minimum_experience, :cb_maximum_experience].freeze

      def valid_options_for_advanced_resume_search?(options)
        (options.keys - VALID_OPTIONS_FOR_ADVANCED_RESUME_SEARCH).empty?
      end

      def perform
        raise ArgumentError unless valid_options_for_advanced_resume_search?(options)
        require_authentication
        options.merge!(:session_token => session_token)
        response = perform_request("V2_AdvancedResumeSearch", transform_options_to_xml(options))

        xml_from_response = parse_terrible_response(response)
        ResumeSearchResult.parse(xml_from_response)
      end

    end

  end

end
