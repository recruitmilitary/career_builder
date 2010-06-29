require 'spec_helper'

describe CareerBuilder::Client do

  describe "#authenticate" do

    context "with valid credentials" do

      before do
        stub_request(:post, "http://ws.careerbuilder.com/resumes/resumes.asmx/BeginSessionV2").with(:body => 'Packet=%3cPacket%3e%3cEmail%3evalid_email%3c%2fEmail%3e%3cPassword%3evalid_password%3c%2fPassword%3e%3c%2fPacket%3e').to_return(:body => "<?xml version=\"1.0\" encoding=\"utf-8\"?>\r\n<string xmlns=\"http://ws.careerbuilder.com/resumes/\">&lt;Packet&gt;&lt;Errors /&gt;&lt;SessionToken&gt;42df77a98a874c6ca8644cf8e8ceffa6-330779842-RY-4&lt;/SessionToken&gt;&lt;/Packet&gt;</string>")
        @client = CareerBuilder::Client.new("valid_email", "valid_password")
      end

      it 'should return true' do
        @client.authenticate.should be_true
      end

      it 'should be authenticated' do
        @client.authenticate
        @client.should be_authenticated
      end

    end

    context "with invalid credentials" do

      before do
        stub_request(:post, "http://ws.careerbuilder.com/resumes/resumes.asmx/BeginSessionV2").with(:body => 'Packet=%3cPacket%3e%3cEmail%3evalid_email%3c%2fEmail%3e%3cPassword%3einvalid_password%3c%2fPassword%3e%3c%2fPacket%3e').to_return(:body => "<?xml version=\"1.0\" encoding=\"utf-8\"?>\r\n<string xmlns=\"http://ws.careerbuilder.com/resumes/\">&lt;Packet&gt;&lt;Errors&gt;&lt;CBError&gt;&lt;Code&gt;300&lt;/Code&gt;&lt;Text&gt;300|Email (ryan@recruitmilitary.com) and password (AZG24N4) could not be validated.&lt;/Text&gt;&lt;/CBError&gt;&lt;/Errors&gt;&lt;SessionToken&gt;Invalid&lt;/SessionToken&gt;&lt;/Packet&gt;</string>")
        @client = CareerBuilder::Client.new("valid_email", "invalid_password")
      end

      it 'should return false' do
        @client.authenticate.should be_false
      end

      it 'should not be authenticated' do
        @client.authenticate
        @client.should_not be_authenticated
      end

    end

  end

  describe "#advanced_resume_search" do

    context "with invalid credentials" do

      before do
        @client = CareerBuilder::Client.new("valid_email", "invalid_password")
        @client.stub(:authenticate).and_return(false)
      end

      context "with valid options" do

        it 'should raise InvalidCredentials' do
          expect {
            @client.advanced_resume_search(:keywords => "Ruby")
          }.to raise_error(CareerBuilder::InvalidCredentials)
        end

      end

      context "with invalid options" do

        it 'should raise ArgumentError' do
          expect {
            @client.advanced_resume_search(:foo => "bar")
          }.to raise_error(ArgumentError)
        end

      end

    end

    context "with valid credentials" do

      before do
        @client = CareerBuilder::Client.new("valid_email", "valid_password")
        @client.stub(:session_token).and_return(42)
        @client.stub(:authenticate).and_return(true)
      end

      context "with valid options" do

        before do
          stub_request(:post, "http://ws.careerbuilder.com/resumes/resumes.asmx/V2_AdvancedResumeSearch").with(:body => 'Packet=%3cPacket%3e%3cSessionToken%3e42%3c%2fSessionToken%3e%3cKeywords%3eRuby%3c%2fKeywords%3e%3c%2fPacket%3e').to_return(:body => "<?xml version=\"1.0\" encoding=\"utf-8\"?>\r\n<string xmlns=\"http://ws.careerbuilder.com/resumes/\">&lt;Packet&gt;&lt;Errors /&gt;&lt;PageNumber&gt;1&lt;/PageNumber&gt;&lt;SearchTime&gt;06/25/2010 12:03:14&lt;/SearchTime&gt;&lt;FirstRec&gt;1&lt;/FirstRec&gt;&lt;LastRec&gt;100&lt;/LastRec&gt;&lt;Hits&gt;3&lt;/Hits&gt;&lt;MaxPage&gt;1&lt;/MaxPage&gt;&lt;Results&gt;&lt;ResumeResultItem_V3&gt;&lt;ContactEmail&gt;Rhd4G067G4JVTLW99H7_A7C14Q67VKG000YBSCR~CBWS^U7A3LY6YY46V1MT0RJK@resume.cbdr.com&lt;/ContactEmail&gt;&lt;ContactName&gt;Rebecca Bernard&lt;/ContactName&gt;&lt;HomeLocation&gt;US-OH-Milford&lt;/HomeLocation&gt;&lt;LastUpdate&gt;2010/5/13&lt;/LastUpdate&gt;&lt;ResumeTitle&gt;BERNARD_SYSTEMS_ENGINEER&lt;/ResumeTitle&gt;&lt;JobTitle&gt;BERNARD_SYSTEMS_ENGINEER&lt;/JobTitle&gt;&lt;RecentEmployer&gt;TATA CONSULTANCY SERVICES&lt;/RecentEmployer&gt;&lt;RecentJobTitle&gt;CONSULTANCY SERVICES- Systems Engineer&lt;/RecentJobTitle&gt;&lt;RecentPay&gt;0&lt;/RecentPay&gt;&lt;ResumeID&gt;Rhd4G067G4JVTLW99H7&lt;/ResumeID&gt;&lt;UserDID&gt;U7X86R61VVKS4FWS03T&lt;/UserDID&gt;&lt;ContactEmailMD5&gt;139013c2fa2b945bdc340f8a698b009e&lt;/ContactEmailMD5&gt;&lt;/ResumeResultItem_V3&gt;&lt;ResumeResultItem_V3&gt;&lt;ContactEmail&gt;Rhe7TZ764LHG1GQTPSM_A7C14Q67VKG000YBSCR~CBWS^U7A3LY6YY46V1MT0RJK@resume.cbdr.com&lt;/ContactEmail&gt;&lt;ContactName&gt;chris grader&lt;/ContactName&gt;&lt;HomeLocation&gt;US-OH-Milford&lt;/HomeLocation&gt;&lt;LastUpdate&gt;2010/6/4&lt;/LastUpdate&gt;&lt;ResumeTitle&gt;Chris Grader resume&lt;/ResumeTitle&gt;&lt;JobTitle&gt;Chris Grader resume&lt;/JobTitle&gt;&lt;RecentEmployer&gt;Millennial Medical, Inc&lt;/RecentEmployer&gt;&lt;RecentJobTitle&gt;Regional Sales Manager/Midwest Distributor&lt;/RecentJobTitle&gt;&lt;RecentPay&gt;0&lt;/RecentPay&gt;&lt;ResumeID&gt;Rhe7TZ764LHG1GQTPSM&lt;/ResumeID&gt;&lt;UserDID&gt;U346V1MKGCHPGCF9S8&lt;/UserDID&gt;&lt;ContactEmailMD5&gt;cfba57bf848b78211d99348cf0f90879&lt;/ContactEmailMD5&gt;&lt;/ResumeResultItem_V3&gt;&lt;ResumeResultItem_V3&gt;&lt;ContactEmail&gt;RH52G867678F7GH02Q3_A7C14Q67VKG000YBSCR~CBWS^U7A3LY6YY46V1MT0RJK@resume.cbdr.com&lt;/ContactEmail&gt;&lt;ContactName&gt;Jeffrey Davis&lt;/ContactName&gt;&lt;HomeLocation&gt;US-OH-Goshen&lt;/HomeLocation&gt;&lt;LastUpdate&gt;2010/5/23&lt;/LastUpdate&gt;&lt;ResumeTitle&gt;Warehouse Distribution Specialist&lt;/ResumeTitle&gt;&lt;JobTitle&gt;Warehouse Distribution Specialist&lt;/JobTitle&gt;&lt;RecentEmployer&gt;OWENS &amp;amp; MINOR&lt;/RecentEmployer&gt;&lt;RecentJobTitle&gt;Warehouse Lead Supervisor&lt;/RecentJobTitle&gt;&lt;RecentPay&gt;35776&lt;/RecentPay&gt;&lt;ResumeID&gt;RH52G867678F7GH02Q3&lt;/ResumeID&gt;&lt;UserDID&gt;U1C29V68M3YM95SP0XK&lt;/UserDID&gt;&lt;ContactEmailMD5&gt;e814ebaa93aae5c3719e27d26d5af917&lt;/ContactEmailMD5&gt;&lt;/ResumeResultItem_V3&gt;&lt;/Results&gt;&lt;/Packet&gt;</string>")
          @search = @client.advanced_resume_search(:keywords => "Ruby")
        end

        it 'should have the correct page number' do
          @search.page_number.should == 1
        end

        it 'should have the correct search time' do
          @search.search_time.should == Time.mktime(2010, 6, 25, 12, 3, 14)
        end

        it 'should return the correct number of hits' do
          @search.hits.should == 3
        end

        it 'should return the correct max page' do
          @search.max_page.should == 1
        end

        describe "#results" do

          before do
            @results = @search.results
            @result  = @results.first
          end

          it 'should return the correct contact email' do
            @result.contact_email.should == "Rhd4G067G4JVTLW99H7_A7C14Q67VKG000YBSCR~CBWS^U7A3LY6YY46V1MT0RJK@resume.cbdr.com"
          end

          it 'should return the correct contact name' do
            @result.contact_name.should == "Rebecca Bernard"
          end

          it 'should return the correct home location' do
            @result.home_location.should == "US-OH-Milford"
          end

          it 'should return the correct last update' do
            @result.last_update.should == Date.new(2010, 5, 13)
          end

          it 'should return the correct resume title' do
            @result.title.should == "BERNARD_SYSTEMS_ENGINEER"
          end

          it 'should return the correct job title' do
            @result.job_title.should == "BERNARD_SYSTEMS_ENGINEER"
          end

          it 'should return the correct recent pay' do
            @result.recent_pay.should == 0
          end

          it 'should return the correct id' do
            @result.id.should == "Rhd4G067G4JVTLW99H7"
          end

          it 'should return the correct user id' do
            @result.user_did.should == "U7X86R61VVKS4FWS03T"
          end

          it 'should return the correct contact email md5' do
            @result.contact_email_md5.should == "139013c2fa2b945bdc340f8a698b009e"
          end

        end

      end

      context "with invalid options" do

        it 'should raise ArgumentError' do
          expect {
            @client.advanced_resume_search(:foo => "bar")
          }.to raise_error(ArgumentError)
        end

      end

    end

  end

  describe "get_resume" do

    context "with invalid credentials" do

      before do
        @client = CareerBuilder::Client.new("valid_email", "invalid_password")
        @client.stub(:authenticate).and_return(false)
      end

      context "with valid options" do

        it 'should raise InvalidCredentials' do
          expect {
            @client.get_resume(:resume_id => "4242424242")
          }.to raise_error(CareerBuilder::InvalidCredentials)
        end

      end

      context "with invalid options" do

        it 'should raise ArgumentError' do
          expect {
            @client.get_resume(:foo => "bar")
          }.to raise_error(ArgumentError)
        end

      end

    end

    context "with valid credentials" do

      before do
        @client = CareerBuilder::Client.new("valid_email", "valid_password")
        @client.stub(:session_token).and_return(42)
        @client.stub(:authenticate).and_return(true)
      end

      context "with invalid options" do

        it 'should raise ArgumentError' do
          expect {
            @client.get_resume(:foo => "bar")
          }.to raise_error(ArgumentError)
        end

      end

      context "when out of credits" do

        before do
          stub_request(:post, "http://ws.careerbuilder.com/resumes/resumes.asmx/V2_GetResume").with(:body => 'Packet=%3cPacket%3e%3cSessionToken%3e42%3c%2fSessionToken%3e%3cResumeID%3eRH52G867678F7GH02Q3%3c%2fResumeID%3e%3c%2fPacket%3e').to_return(:body => "<?xml version=\"1.0\" encoding=\"utf-8\"?>\r\n<string xmlns=\"http://ws.careerbuilder.com/resumes/\">&lt;Packet&gt;&lt;Warning&gt;&lt;/Warning&gt;&lt;/Packet&gt;</string>")
        end

        it 'should raise OutOfCredits' do
          expect {
            @resume = @client.get_resume(:resume_id => "RH52G867678F7GH02Q3")
          }.to raise_error(CareerBuilder::OutOfCredits)
        end

      end

      context "with valid options" do

        before do
          stub_request(:post, "http://ws.careerbuilder.com/resumes/resumes.asmx/V2_GetResume").with(:body => 'Packet=%3cPacket%3e%3cSessionToken%3e42%3c%2fSessionToken%3e%3cResumeID%3eRH52G867678F7GH02Q3%3c%2fResumeID%3e%3c%2fPacket%3e').to_return(:body => "<?xml version=\"1.0\" encoding=\"utf-8\"?>\r\n<string xmlns=\"http://ws.careerbuilder.com/resumes/\">&lt;Packet&gt;&lt;TimeStamp&gt;6/25/2010 3:19:20 PM&lt;/TimeStamp&gt;&lt;ResumeID&gt;RH52G867678F7GH02Q3&lt;/ResumeID&gt;&lt;ResumeTitle&gt;Warehouse Distribution Specialist&lt;/ResumeTitle&gt;&lt;ContactName&gt;Jeffrey Davis&lt;/ContactName&gt;&lt;ContactEmail&gt;Jeffd1969@aol.com&lt;/ContactEmail&gt;&lt;ContactPhone&gt;513-625-7228&lt;/ContactPhone&gt;&lt;HomeLocation&gt;&lt;City&gt;Goshen&lt;/City&gt;&lt;State&gt;OH&lt;/State&gt;&lt;Country&gt;US&lt;/Country&gt;&lt;ZipCode&gt;45122&lt;/ZipCode&gt;&lt;WorkStatus&gt;Can work for any employer&lt;/WorkStatus&gt;&lt;/HomeLocation&gt;&lt;Relocations&gt;&lt;ExtLocation&gt;&lt;City&gt;Tokyo&lt;/City&gt;&lt;State/&gt;&lt;Country&gt;JP&lt;/Country&gt;&lt;ZipCode /&gt;&lt;WorkStatus&gt;Can work for any employer&lt;/WorkStatus&gt;&lt;/ExtLocation&gt;&lt;/Relocations&gt;&lt;MaxCommuteMiles&gt;10&lt;/MaxCommuteMiles&gt;&lt;TravelPreference&gt;Up to 25%&lt;/TravelPreference&gt;&lt;CurrentlyEmployed&gt;Yes&lt;/CurrentlyEmployed&gt;&lt;MostRecentPay&gt;&lt;Amount&gt;35776&lt;/Amount&gt;&lt;Per&gt;year&lt;/Per&gt;&lt;/MostRecentPay&gt;&lt;DesiredPay&gt;&lt;Amount&gt;45000&lt;/Amount&gt;&lt;Per&gt;year&lt;/Per&gt;&lt;/DesiredPay&gt;&lt;DesiredJobTypes&gt;&lt;string&gt;Full Time&lt;/string&gt;&lt;/DesiredJobTypes&gt;&lt;MostRecentTitle&gt;Warehouse Lead Supervisor&lt;/MostRecentTitle&gt;&lt;ExperienceMonths&gt;216&lt;/ExperienceMonths&gt;&lt;Management&gt;&lt;ManagedOthers&gt;No&lt;/ManagedOthers&gt;&lt;NumberManaged&gt;0&lt;/NumberManaged&gt;&lt;/Management&gt;&lt;JobsLastThreeYears&gt;0&lt;/JobsLastThreeYears&gt;&lt;LastJobTenureMonths&gt;0&lt;/LastJobTenureMonths&gt;&lt;SecurityClearance&gt;No&lt;/SecurityClearance&gt;&lt;FelonyConvictions&gt;No&lt;/FelonyConvictions&gt;&lt;HighestDegree&gt;None&lt;/HighestDegree&gt;&lt;Certifications /&gt;&lt;MotivationToChangeJobs /&gt;&lt;EmploymentType /&gt;&lt;LastUpdated&gt;5/23/2010 10:41:12 PM&lt;/LastUpdated&gt;&lt;Languages&gt;&lt;string&gt;English&lt;/string&gt;&lt;/Languages&gt;&lt;DesiredShiftPreferences&gt;&lt;string /&gt;&lt;/DesiredShiftPreferences&gt;&lt;Interests&gt;&lt;ExtInterest&gt;&lt;Interest&gt;Warehouse&lt;/Interest&gt;&lt;ExperienceMonths&gt;216&lt;/ExperienceMonths&gt;&lt;/ExtInterest&gt;&lt;/Interests&gt;&lt;ResumeText&gt;JEFFREY A. DAVIS&lt;/ResumeText&gt;&lt;MilitaryExperience&gt;Veteran&lt;/MilitaryExperience&gt;&lt;WorkHistory&gt;&lt;ExtCompany&gt;&lt;CompanyName&gt;OWENS &amp;amp; MINOR&lt;/CompanyName&gt;&lt;JobTitle&gt;Warehouse Lead Supervisor&lt;/JobTitle&gt;&lt;Tenure&gt;01/01/2008 - Present&lt;/Tenure&gt;&lt;/ExtCompany&gt;&lt;ExtCompany&gt;&lt;CompanyName&gt;THE HOME DEPOT&lt;/CompanyName&gt;&lt;JobTitle&gt;- Sales Specialist&lt;/JobTitle&gt;&lt;Tenure&gt;01/01/2005 - Present&lt;/Tenure&gt;&lt;/ExtCompany&gt;&lt;ExtCompany&gt;&lt;CompanyName&gt;RUBIES COSTUME CO&lt;/CompanyName&gt;&lt;JobTitle&gt;- Warehouse Assistant Manager&lt;/JobTitle&gt;&lt;Tenure&gt;01/01/2004 - 01/01/2006&lt;/Tenure&gt;&lt;/ExtCompany&gt;&lt;ExtCompany&gt;&lt;CompanyName&gt;UNITED ELECTRIC POWER&lt;/CompanyName&gt;&lt;JobTitle&gt;Inventory Operations Manager&lt;/JobTitle&gt;&lt;Tenure&gt;01/01/2000 - 01/01/2004&lt;/Tenure&gt;&lt;/ExtCompany&gt;&lt;ExtCompany&gt;&lt;CompanyName&gt;VEECO INSTRUMENTS, INC&lt;/CompanyName&gt;&lt;JobTitle&gt;Warehouse Supervisor&lt;/JobTitle&gt;&lt;Tenure&gt;01/01/1996 - 01/01/2000&lt;/Tenure&gt;&lt;/ExtCompany&gt;&lt;/WorkHistory&gt;&lt;EducationHistory&gt;&lt;ExtSchool&gt;&lt;SchoolName&gt;Eastern Oklahoma State College&lt;/SchoolName&gt;&lt;Major&gt;Business Management&lt;/Major&gt;&lt;Degree /&gt;&lt;GraduationDate&gt;11993&lt;/GraduationDate&gt;&lt;/ExtSchool&gt;&lt;ExtSchool&gt;&lt;SchoolName&gt;Suffolk County Community College&lt;/SchoolName&gt;&lt;Major&gt;Business Management&lt;/Major&gt;&lt;Degree /&gt;&lt;GraduationDate&gt;11997&lt;/GraduationDate&gt;&lt;/ExtSchool&gt;&lt;/EducationHistory&gt;&lt;Warning&gt;&lt;/Warning&gt;&lt;/Packet&gt;</string>")
          @resume = @client.get_resume(:resume_id => "RH52G867678F7GH02Q3")
        end

        it 'should return the correct timestamp' do
          @resume.timestamp.should == Time.mktime(2010, 6, 25, 15, 19, 20)
        end

        it 'should return the correct id' do
          @resume.id.should == "RH52G867678F7GH02Q3"
        end

        it 'should return the correct title' do
          @resume.title.should == "Warehouse Distribution Specialist"
        end

        it 'should return the correct contact name' do
          @resume.contact_name.should == "Jeffrey Davis"
        end

        it 'should return the correct contact email' do
          @resume.contact_email.should == "Jeffd1969@aol.com"
        end

        it 'should return the correct contact phone' do
          @resume.contact_phone.should == "513-625-7228"
        end

        describe "#home_location" do

          before do
            @home_location = @resume.home_location
          end

          it 'should return the correct city' do
            @home_location.city.should == "Goshen"
          end

          it 'should return the correct state' do
            @home_location.state.should == "OH"
          end

          it 'should return the correct zip code' do
            @home_location.zip_code.should == "45122"
          end

          it 'should return the correct country' do
            @home_location.country.should == "US"
          end

          it 'should return the correct work status' do
            @home_location.work_status.should == "Can work for any employer"
          end

        end

        describe "#relocations" do

          before do
            @relocations = @resume.relocations
            @relocation  = @relocations.first
          end

          it 'should return the correct city' do
            @relocation.city.should == "Tokyo"
          end

          it 'should return the correct state' do
            @relocation.state.should == ""
          end

          it 'should return the correct zip code' do
            @relocation.zip_code.should == ""
          end

          it 'should return the correct country' do
            @relocation.country.should == "JP"
          end

          it 'should return the correct work status' do
            @relocation.work_status.should == "Can work for any employer"
          end

        end

        it 'should return the correct max commute miles' do
          @resume.max_commute_miles.should == 10
        end

        it 'should return the correct travel preference' do
          @resume.travel_preference.should == "Up to 25%"
        end

        it 'should return the correct currently employed' do
          @resume.currently_employed.should == "Yes"
        end

        describe "#most_recent_pay" do

          before do
            @most_recent_pay = @resume.most_recent_pay
          end

          it 'should return the correct amount' do
            @most_recent_pay.amount.should == 35776
          end

          it 'should return the correct per' do
            @most_recent_pay.per.should == "year"
          end

        end

        describe "#desired_pay" do

          before do
            @desired_pay = @resume.desired_pay
          end

          it 'should return the correct amount' do
            @desired_pay.amount.should == 45000
          end

          it 'should return the correct per' do
            @desired_pay.per.should == "year"
          end

        end

        describe "#desired_job_types" do

          before do
            @desired_job_types = @resume.desired_job_types
            @desired_job_type  = @desired_job_types.first
          end

          it 'should return the correct text' do
            @desired_job_type.text.should == "Full Time"
          end

        end

        it 'should return the correct most recent title' do
          @resume.most_recent_title.should == "Warehouse Lead Supervisor"
        end

        it 'should return the correct experience months' do
          @resume.experience_months.should == 216
        end

        it 'should return the correct managed others' do
          @resume.managed_others.should == "No"
        end

        it 'should return the correct number managed' do
          @resume.number_managed.should == 0
        end

        it 'should return the correct jobs last three years' do
          @resume.jobs_last_three_years.should == 0
        end

        it 'should return the correct last job tenure months' do
          @resume.last_job_tenure_months.should == 0
        end

        it 'should return the correct security clearance' do
          @resume.security_clearance.should == "No"
        end

        it 'should return the correct felony convictions' do
          @resume.felony_convictions.should == "No"
        end

        it 'should return the correct highest degree' do
          @resume.highest_degree.should == "None"
        end

        it 'should return the correct certifications' do
          @resume.certifications.should == ""
        end

        it 'should return the correct motivation to change jobs' do
          @resume.motivation_to_change_jobs.should == ""
        end

        it 'should return the correct employment type' do
          @resume.employment_type.should == ""
        end

        it 'should return the correct last updated' do
          @resume.last_updated.should == Time.mktime(2010, 5, 23, 22, 41, 12)
        end

        describe "#languages" do

          before do
            @languages = @resume.languages
            @language  = @languages.first
          end

          it 'should return the correct text' do
            @language.text.should == "English"
          end

        end

        describe "#desired_shift_preferences" do

          before do
            @desired_shift_preferences = @resume.desired_shift_preferences
            @desired_shift_preference  = @desired_shift_preferences.first
          end

          it 'should return the correct desired shift preferences' do
            @desired_shift_preference.text.should == ""
          end

        end

        describe "#interests" do

          before do
            @interests = @resume.interests
            @interest  = @interests.first
          end

          it 'should return the correct interest' do
            @interest.interest.should == "Warehouse"
          end

          it 'should return the correct experience in months' do
            @interest.experience_months.should == 216
          end

        end

        it 'should return the correct resume text' do
          @resume.text.should == "JEFFREY A. DAVIS"
        end

        it 'should return the military experience' do
          @resume.military_experience.should == "Veteran"
        end

        describe "#companies" do

          before do
            @companies = @resume.companies
            @company   = @companies.first
          end

          it 'should return the correct company name' do
            @company.name.should == "OWENS & MINOR"
          end

          it 'should return the correct job title' do
            @company.job_title.should == "Warehouse Lead Supervisor"
          end

          it 'should return the correct tenure' do
            @company.tenure.should == "01/01/2008 - Present"
          end

        end

        describe "#schools" do

          before do
            @schools = @resume.schools
            @school  = @schools.first
          end

          it 'should return the correct school name' do
            @school.name.should == "Eastern Oklahoma State College"
          end

          it 'should return the correct major' do
            @school.major.should == "Business Management"
          end

          it 'should return the correct degree' do
            @school.degree.should == ""
          end

          it 'should return the correct graduation date' do
            @school.graduation_date.should == "11993"
          end

        end

        it 'should return the correct warning' do
          @resume.warning.should == ""
        end

      end

    end

  end

  describe "#resume_actions_remaining_today" do

    before do
      stub_request(:post, "http://ws.careerbuilder.com/resumes/resumes.asmx/V2_ResumeActionsRemainingToday").with(:body => 'Packet=%3cPacket%3e%3cSessionToken%3e42%3c%2fSessionToken%3e%3cAccountDID%3eD7D15Q67VKG105ZB12%3c%2fAccountDID%3e%3c%2fPacket%3e').to_return(:body => "<?xml version=\"1.0\" encoding=\"utf-8\"?>\r\n<string xmlns=\"http://ws.careerbuilder.com/resumes/\">&lt;Packet&gt;1&lt;/Packet&gt;</string>")
      @client = CareerBuilder::Client.new("valid_email", "valid_password")
      @client.stub(:session_token).and_return(42)
      @client.stub(:authenticate).and_return(true)
    end

    it 'should return the number of credits remaining' do
      @client.resume_actions_remaining_today(:account_did => "D7D15Q67VKG105ZB12").should == 1
    end

  end

end
