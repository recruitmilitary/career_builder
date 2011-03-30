module CareerBuilder
  class Client
    module AdvancedResumeSearch

      # List of valid options available at:
      # http://ws.careerbuilder.com/resumes/resumes.asmx/V2_AdvancedResumeSearch_ValidFields
      #
      VALID_OPTIONS = [:keywords, :search_pattern, :job_categories,
                       :city, :state, :zip_code, :country,
                       :search_radius_in_miles, :relocation_filter,
                       :freshness_in_days, :employment_type,
                       :minimum_experience,
                       :minimum_travel_requirement, :minimum_degree,
                       :compensation_type, :minimum_salary,
                       :maximum_salary,
                       :exclude_resumes_with_no_salary,
                       :languages_spoken, :currently_employed,
                       :management_experience,
                       :minimum_employees_managed, :maximum_commute,
                       :security_clearance, :work_status,
                       :exclude_ivr_resumes, :order_by, :page_number,
                       :rows_per_page, :cust_acct_code, :custom_xml,
                       :military_experience, :niche_inclusion,
                       :lemmatize, :job_title, :company, :school,
                       :rsadid, :cb_minimum_experience,
                       :cb_maximum_experience].freeze

      def advanced_resume_search(options = {})
        unless (invalid_options = options.keys - VALID_OPTIONS).empty?
          raise ArgumentError, "Invalid options #{invalid_options}"
        end

        response = auth_request("V2_AdvancedResumeSearch", options)

        API::ResumeSearch.parse(response)
      end

    end
  end
end
