require 'spec_helper'

describe CareerBuilder::Client do

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

end
