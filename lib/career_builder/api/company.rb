module CareerBuilder
  
  module API

    class Company

      include HappyMapper

      element :name, String, :tag => "CompanyName"
      element :job_title, String, :tag => "JobTitle"
      element :tenure, String, :tag => "Tenure"

    end

  end
  
end
