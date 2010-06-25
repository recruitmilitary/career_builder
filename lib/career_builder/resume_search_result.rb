module CareerBuilder

  class ResumeSearchResult

    include HappyMapper

    tag 'ResumeResultItem_V3'

    element :contact_email, String, :tag => "ContactEmail"
    element :contact_name, String, :tag => "ContactName"
    element :home_location, String, :tag => "HomeLocation"
    element :last_update, Date, :tag => "LastUpdate"
    element :title, String, :tag => "ResumeTitle"
    element :job_title, String, :tag => "JobTitle"
    element :recent_employer, String, :tag => "RecentEmployer"
    element :recent_job_title, String, :tag => "RecentJobTitle"
    element :recent_pay, String, :tag => "RecentPay"
    element :id, String, :tag => "ResumeID"
    element :user_did, String, :tag => "UserDID"
    element :contact_email_md5, String, :tag => "ContactEmailMD5"

  end

end
