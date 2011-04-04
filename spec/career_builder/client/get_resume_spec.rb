require 'spec_helper'

describe CareerBuilder::Client do

  describe "#get_resume" do
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
        RAW_RESUME_RESPONSE =  "<?xml version=\"1.0\" encoding=\"utf-8\"?>\r\n<string xmlns=\"http://ws.careerbuilder.com/resumes/\">&lt;Packet&gt;&lt;TimeStamp&gt;6/25/2010 3:19:20 PM&lt;/TimeStamp&gt;&lt;ResumeID&gt;RH52G867678F7GH02Q3&lt;/ResumeID&gt;&lt;ResumeTitle&gt;Warehouse Distribution Specialist&lt;/ResumeTitle&gt;&lt;ContactName&gt;Jeffrey Davis&lt;/ContactName&gt;&lt;ContactEmail&gt;Jeffd1969@aol.com&lt;/ContactEmail&gt;&lt;ContactPhone&gt;513-625-7228&lt;/ContactPhone&gt;&lt;HomeLocation&gt;&lt;City&gt;Goshen&lt;/City&gt;&lt;State&gt;OH&lt;/State&gt;&lt;Country&gt;US&lt;/Country&gt;&lt;ZipCode&gt;45122&lt;/ZipCode&gt;&lt;WorkStatus&gt;Can work for any employer&lt;/WorkStatus&gt;&lt;/HomeLocation&gt;&lt;Relocations&gt;&lt;ExtLocation&gt;&lt;City&gt;Tokyo&lt;/City&gt;&lt;State/&gt;&lt;Country&gt;JP&lt;/Country&gt;&lt;ZipCode /&gt;&lt;WorkStatus&gt;Can work for any employer&lt;/WorkStatus&gt;&lt;/ExtLocation&gt;&lt;/Relocations&gt;&lt;MaxCommuteMiles&gt;10&lt;/MaxCommuteMiles&gt;&lt;TravelPreference&gt;Up to 25%&lt;/TravelPreference&gt;&lt;CurrentlyEmployed&gt;Yes&lt;/CurrentlyEmployed&gt;&lt;MostRecentPay&gt;&lt;Amount&gt;35776&lt;/Amount&gt;&lt;Per&gt;year&lt;/Per&gt;&lt;/MostRecentPay&gt;&lt;DesiredPay&gt;&lt;Amount&gt;45000&lt;/Amount&gt;&lt;Per&gt;year&lt;/Per&gt;&lt;/DesiredPay&gt;&lt;DesiredJobTypes&gt;&lt;string&gt;Full Time&lt;/string&gt;&lt;/DesiredJobTypes&gt;&lt;MostRecentTitle&gt;Warehouse Lead Supervisor&lt;/MostRecentTitle&gt;&lt;ExperienceMonths&gt;216&lt;/ExperienceMonths&gt;&lt;Management&gt;&lt;ManagedOthers&gt;No&lt;/ManagedOthers&gt;&lt;NumberManaged&gt;0&lt;/NumberManaged&gt;&lt;/Management&gt;&lt;JobsLastThreeYears&gt;0&lt;/JobsLastThreeYears&gt;&lt;LastJobTenureMonths&gt;0&lt;/LastJobTenureMonths&gt;&lt;SecurityClearance&gt;No&lt;/SecurityClearance&gt;&lt;FelonyConvictions&gt;No&lt;/FelonyConvictions&gt;&lt;HighestDegree&gt;None&lt;/HighestDegree&gt;&lt;Certifications /&gt;&lt;MotivationToChangeJobs /&gt;&lt;EmploymentType /&gt;&lt;LastUpdated&gt;5/23/2010 10:41:12 PM&lt;/LastUpdated&gt;&lt;Languages&gt;&lt;string&gt;English&lt;/string&gt;&lt;/Languages&gt;&lt;DesiredShiftPreferences&gt;&lt;string /&gt;&lt;/DesiredShiftPreferences&gt;&lt;Interests&gt;&lt;ExtInterest&gt;&lt;Interest&gt;Warehouse&lt;/Interest&gt;&lt;ExperienceMonths&gt;216&lt;/ExperienceMonths&gt;&lt;/ExtInterest&gt;&lt;/Interests&gt;&lt;ResumeText&gt;JEFFREY A. DAVIS&lt;/ResumeText&gt;&lt;MilitaryExperience&gt;Veteran&lt;/MilitaryExperience&gt;&lt;WorkHistory&gt;&lt;ExtCompany&gt;&lt;CompanyName&gt;OWENS &amp;amp; MINOR&lt;/CompanyName&gt;&lt;JobTitle&gt;Warehouse Lead Supervisor&lt;/JobTitle&gt;&lt;Tenure&gt;01/01/2008 - Present&lt;/Tenure&gt;&lt;/ExtCompany&gt;&lt;ExtCompany&gt;&lt;CompanyName&gt;THE HOME DEPOT&lt;/CompanyName&gt;&lt;JobTitle&gt;- Sales Specialist&lt;/JobTitle&gt;&lt;Tenure&gt;01/01/2005 - Present&lt;/Tenure&gt;&lt;/ExtCompany&gt;&lt;ExtCompany&gt;&lt;CompanyName&gt;RUBIES COSTUME CO&lt;/CompanyName&gt;&lt;JobTitle&gt;- Warehouse Assistant Manager&lt;/JobTitle&gt;&lt;Tenure&gt;01/01/2004 - 01/01/2006&lt;/Tenure&gt;&lt;/ExtCompany&gt;&lt;ExtCompany&gt;&lt;CompanyName&gt;UNITED ELECTRIC POWER&lt;/CompanyName&gt;&lt;JobTitle&gt;Inventory Operations Manager&lt;/JobTitle&gt;&lt;Tenure&gt;01/01/2000 - 01/01/2004&lt;/Tenure&gt;&lt;/ExtCompany&gt;&lt;ExtCompany&gt;&lt;CompanyName&gt;VEECO INSTRUMENTS, INC&lt;/CompanyName&gt;&lt;JobTitle&gt;Warehouse Supervisor&lt;/JobTitle&gt;&lt;Tenure&gt;01/01/1996 - 01/01/2000&lt;/Tenure&gt;&lt;/ExtCompany&gt;&lt;/WorkHistory&gt;&lt;EducationHistory&gt;&lt;ExtSchool&gt;&lt;SchoolName&gt;Eastern Oklahoma State College&lt;/SchoolName&gt;&lt;Major&gt;Business Management&lt;/Major&gt;&lt;Degree /&gt;&lt;GraduationDate&gt;11993&lt;/GraduationDate&gt;&lt;/ExtSchool&gt;&lt;ExtSchool&gt;&lt;SchoolName&gt;Suffolk County Community College&lt;/SchoolName&gt;&lt;Major&gt;Business Management&lt;/Major&gt;&lt;Degree /&gt;&lt;GraduationDate&gt;11997&lt;/GraduationDate&gt;&lt;/ExtSchool&gt;&lt;/EducationHistory&gt;&lt;Warning&gt;&lt;/Warning&gt;&lt;/Packet&gt;</string>".freeze

        before do
          stub_request(:post, "http://ws.careerbuilder.com/resumes/resumes.asmx/V2_GetResume").with(:body => 'Packet=%3cPacket%3e%3cSessionToken%3e42%3c%2fSessionToken%3e%3cResumeID%3eRH52G867678F7GH02Q3%3c%2fResumeID%3e%3c%2fPacket%3e').to_return(:body => RAW_RESUME_RESPONSE)
          @resume = @client.get_resume(:resume_id => "RH52G867678F7GH02Q3")
        end

        # despite the fact that career builder gives us jacked up
        # double encoded XML, let's retrieve the Resume#raw_response
        # in a sane way.
        it 'should return the raw response' do
          @resume.raw_response.should == "<?xml version=\"1.0\" encoding=\"utf-8\"?>\n<string xmlns=\"http://ws.careerbuilder.com/resumes/\"><Packet><TimeStamp>6/25/2010 3:19:20 PM</TimeStamp><ResumeID>RH52G867678F7GH02Q3</ResumeID><ResumeTitle>Warehouse Distribution Specialist</ResumeTitle><ContactName>Jeffrey Davis</ContactName><ContactEmail>Jeffd1969@aol.com</ContactEmail><ContactPhone>513-625-7228</ContactPhone><HomeLocation><City>Goshen</City><State>OH</State><Country>US</Country><ZipCode>45122</ZipCode><WorkStatus>Can work for any employer</WorkStatus></HomeLocation><Relocations><ExtLocation><City>Tokyo</City><State/><Country>JP</Country><ZipCode /><WorkStatus>Can work for any employer</WorkStatus></ExtLocation></Relocations><MaxCommuteMiles>10</MaxCommuteMiles><TravelPreference>Up to 25%</TravelPreference><CurrentlyEmployed>Yes</CurrentlyEmployed><MostRecentPay><Amount>35776</Amount><Per>year</Per></MostRecentPay><DesiredPay><Amount>45000</Amount><Per>year</Per></DesiredPay><DesiredJobTypes><string>Full Time</string></DesiredJobTypes><MostRecentTitle>Warehouse Lead Supervisor</MostRecentTitle><ExperienceMonths>216</ExperienceMonths><Management><ManagedOthers>No</ManagedOthers><NumberManaged>0</NumberManaged></Management><JobsLastThreeYears>0</JobsLastThreeYears><LastJobTenureMonths>0</LastJobTenureMonths><SecurityClearance>No</SecurityClearance><FelonyConvictions>No</FelonyConvictions><HighestDegree>None</HighestDegree><Certifications /><MotivationToChangeJobs /><EmploymentType /><LastUpdated>5/23/2010 10:41:12 PM</LastUpdated><Languages><string>English</string></Languages><DesiredShiftPreferences><string /></DesiredShiftPreferences><Interests><ExtInterest><Interest>Warehouse</Interest><ExperienceMonths>216</ExperienceMonths></ExtInterest></Interests><ResumeText>JEFFREY A. DAVIS</ResumeText><MilitaryExperience>Veteran</MilitaryExperience><WorkHistory><ExtCompany><CompanyName>OWENS &amp; MINOR</CompanyName><JobTitle>Warehouse Lead Supervisor</JobTitle><Tenure>01/01/2008 - Present</Tenure></ExtCompany><ExtCompany><CompanyName>THE HOME DEPOT</CompanyName><JobTitle>- Sales Specialist</JobTitle><Tenure>01/01/2005 - Present</Tenure></ExtCompany><ExtCompany><CompanyName>RUBIES COSTUME CO</CompanyName><JobTitle>- Warehouse Assistant Manager</JobTitle><Tenure>01/01/2004 - 01/01/2006</Tenure></ExtCompany><ExtCompany><CompanyName>UNITED ELECTRIC POWER</CompanyName><JobTitle>Inventory Operations Manager</JobTitle><Tenure>01/01/2000 - 01/01/2004</Tenure></ExtCompany><ExtCompany><CompanyName>VEECO INSTRUMENTS, INC</CompanyName><JobTitle>Warehouse Supervisor</JobTitle><Tenure>01/01/1996 - 01/01/2000</Tenure></ExtCompany></WorkHistory><EducationHistory><ExtSchool><SchoolName>Eastern Oklahoma State College</SchoolName><Major>Business Management</Major><Degree /><GraduationDate>11993</GraduationDate></ExtSchool><ExtSchool><SchoolName>Suffolk County Community College</SchoolName><Major>Business Management</Major><Degree /><GraduationDate>11997</GraduationDate></ExtSchool></EducationHistory><Warning></Warning></Packet></string>"
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

end
