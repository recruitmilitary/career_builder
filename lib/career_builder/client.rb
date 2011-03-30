require 'career_builder/client/authentication'
require 'career_builder/client/request'
require 'career_builder/client/advanced_resume_search'
require 'career_builder/client/get_resume'
require 'career_builder/client/resume_actions_remaining_today'

module CareerBuilder

  class Client

    include Authentication
    include Request
    include AdvancedResumeSearch
    include GetResume
    include ResumeActionsRemainingToday

    attr_reader :email, :password

    def initialize(email, password)
      @email, @password = email, password
    end

    def resumes(options = {})
      Resume::LazyCollection.new(self, options)
    end

  end

end
