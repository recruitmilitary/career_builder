module CareerBuilder

  class Client

    attr_reader :email, :password, :session_token

    def initialize(email, password)
      @email, @password = email, password
    end

    def authenticate
      @session_token = Requests::Authentication.new(self, :email => email, :password => password).perform
    end

    def authenticated?
      !session_token.nil?
    end

    def resumes(options = {})
      Resume::LazyCollection.new(options)
    end

    def advanced_resume_search(options = {})
      Requests::AdvancedResumeSearch.new(self, options).perform
    end

    def get_resume(options = {})
      Requests::GetResume.new(self, options).perform
    end

  end

end
