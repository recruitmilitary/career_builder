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
        end

        it 'should return a collection of resumes that match the criteria' do
          @results = @client.advanced_resume_search(:keywords => "Ruby")
          @results.should_not be_empty
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

      context "with valid options" do

        before do
          stub_request(:post, "http://ws.careerbuilder.com/resumes/resumes.asmx/V2_GetResume").with(:body => 'Packet=%3cPacket%3e%3cSessionToken%3e42%3c%2fSessionToken%3e%3cResumeID%3eRH52G867678F7GH02Q3%3c%2fResumeID%3e%3c%2fPacket%3e').to_return(:body => "<?xml version=\"1.0\" encoding=\"utf-8\"?>\r\n<string xmlns=\"http://ws.careerbuilder.com/resumes/\">&lt;Packet&gt;&lt;TimeStamp&gt;6/25/2010 3:19:20 PM&lt;/TimeStamp&gt;&lt;ResumeID&gt;RH52G867678F7GH02Q3&lt;/ResumeID&gt;&lt;ResumeTitle&gt;Warehouse Distribution Specialist&lt;/ResumeTitle&gt;&lt;ContactName&gt;Jeffrey Davis&lt;/ContactName&gt;&lt;ContactEmail&gt;Jeffd1969@aol.com&lt;/ContactEmail&gt;&lt;ContactPhone&gt;513-625-7228&lt;/ContactPhone&gt;&lt;HomeLocation&gt;&lt;City&gt;Goshen&lt;/City&gt;&lt;State&gt;OH&lt;/State&gt;&lt;Country&gt;US&lt;/Country&gt;&lt;ZipCode&gt;45122&lt;/ZipCode&gt;&lt;WorkStatus&gt;Can work for any employer&lt;/WorkStatus&gt;&lt;/HomeLocation&gt;&lt;Relocations /&gt;&lt;MaxCommuteMiles&gt;10&lt;/MaxCommuteMiles&gt;&lt;TravelPreference&gt;Up to 25%&lt;/TravelPreference&gt;&lt;CurrentlyEmployed&gt;Yes&lt;/CurrentlyEmployed&gt;&lt;MostRecentPay&gt;&lt;Amount&gt;35776&lt;/Amount&gt;&lt;Per&gt;year&lt;/Per&gt;&lt;/MostRecentPay&gt;&lt;DesiredPay&gt;&lt;Amount&gt;45000&lt;/Amount&gt;&lt;Per&gt;year&lt;/Per&gt;&lt;/DesiredPay&gt;&lt;DesiredJobTypes&gt;&lt;string&gt;Full Time&lt;/string&gt;&lt;/DesiredJobTypes&gt;&lt;MostRecentTitle&gt;Warehouse Lead Supervisor&lt;/MostRecentTitle&gt;&lt;ExperienceMonths&gt;216&lt;/ExperienceMonths&gt;&lt;Management&gt;&lt;ManagedOthers&gt;No&lt;/ManagedOthers&gt;&lt;NumberManaged&gt;0&lt;/NumberManaged&gt;&lt;/Management&gt;&lt;JobsLastThreeYears&gt;0&lt;/JobsLastThreeYears&gt;&lt;LastJobTenureMonths&gt;0&lt;/LastJobTenureMonths&gt;&lt;SecurityClearance&gt;No&lt;/SecurityClearance&gt;&lt;FelonyConvictions&gt;No&lt;/FelonyConvictions&gt;&lt;HighestDegree&gt;None&lt;/HighestDegree&gt;&lt;Certifications /&gt;&lt;MotivationToChangeJobs /&gt;&lt;EmploymentType /&gt;&lt;LastUpdated&gt;5/23/2010 10:41:12 PM&lt;/LastUpdated&gt;&lt;Languages&gt;&lt;string&gt;English&lt;/string&gt;&lt;/Languages&gt;&lt;DesiredShiftPreferences&gt;&lt;string /&gt;&lt;/DesiredShiftPreferences&gt;&lt;Interests&gt;&lt;ExtInterest&gt;&lt;Interest&gt;Warehouse&lt;/Interest&gt;&lt;ExperienceMonths&gt;216&lt;/ExperienceMonths&gt;&lt;/ExtInterest&gt;&lt;/Interests&gt;&lt;ResumeText&gt;JEFFREY A. DAVIS                                                     6713\r\nBray Road   Goshen, OH 45122\r\nJeffd1969@aol.com\r\nHm 513-625-7228    Cell 513-679-1446\r\n\r\n\r\nSUMMARY OF QUALIFICATIONS\r\n\r\n        Warehouse/Inventory professional with over 18 years experience\r\n        optimizing operations in distribution and\r\n        manufacturing.  Expert in development and implementation of\r\n        successful operations.  Proven track\r\n        record of turning around troubled operations, establishing\r\n        successful operational procedures,  restructuring\r\n        organizations and training employees.  Management style focuses\r\n        on interdepartmental teamwork with a\r\n        hands-on approach.  This allows me to motivate and maximize\r\n        everyone's potential.\r\n\r\nPROFESSIONAL EXPERIENCE\r\n\r\n                             OWENS &amp;amp; MINOR,  Hebron, KY - Warehouse Lead\r\n                             Supervisor  (2008 - present)\r\n\r\n         Lead Supervisor for this multimillion dollar distributor of\r\n         medical supplies.   I run all shipping operations for several\r\n         major hospital groups.   The largest being Ohio State University\r\n         as well as Good Sam, Bethesda North, Childrens and the PHP\r\n         group.  O&amp;amp;M is the nation's largest distributor of national\r\n         name-brand medical and surgical supplies.  My logistics\r\n         expertise along with state of the art technologies allows me to\r\n         run an extremely efficient operation.  I oversee over 40\r\n         warehouse workers and make sure all pallets shipped are\r\n         compliant with O&amp;amp;M's strict guidelines.  We audit picked product\r\n         daily and utilize a check and balance procedure to maximize our\r\n         efforts to make sure all our customers receive their products\r\n         not only accurately but in a timely manner.\r\n\r\n\r\n                            THE HOME DEPOT, Beechmont, OH - Sales\r\n                            Specialist  (2005-Present)\r\n\r\n         Skilled trade professional in the Millwork, lumber and building\r\n         materials departments.  I am responsible for providing\r\n         customers with professional advice on getting their home\r\n         projects done correctly and to offer guidance on what tools and\r\n         products are best for the job.   Muti-tasking is a norm on an\r\n         everyday basis.  Expert in various machinery that cuts wood\r\n         and other building materials.   Expert driver of several\r\n         different forklifts.  Responsible for loading and unloading\r\n         merchandise.   Responsible for maintaining inventory and keeping\r\n         customers and the store safe.   Member of the\r\n         \"In-Focus\" safety/loss prevention team.\r\n\r\n                            RUBIES COSTUME CO.  Bayshore, NY - Warehouse\r\n                            Assistant Manager  (2004-2006)\r\n\r\n    Supervise day to day operations of 70+ employees for this\r\n    multi-million dollar distributor and pick-pack operation\r\nof costumes and novelty items.  Responsible for the logistics and\r\nensuring that all merchandise is received and shipped\r\nas per sensitive vendor restrictions.  Prepared all vendor instructions\r\nin every aspect; pricing, bar-coding, packaging and\r\nshipping as per vendors sensitive specifications.  Managed all inventory\r\nand consulted with several of our manufacturers to\r\nverify, correct and/or enhance merchandise and its packaging. Responsible\r\nfor efficiency of the warehouse, increasing\r\nproductivity, cutting costs and reducing overtime.\r\n\r\n         UNITED ELECTRIC POWER,  Hicksville, NY - Inventory Operations\r\n         Manager  (2000 - 2004)\r\n\r\n         Supervised and controlled all material flow and inventory\r\n         transactions in this fast-paced, high volume electrical supply\r\n         company.  Established and documented operational procedures\r\n         concerning all material flow.  Prepared yearly returns of\r\n         obsolete and/or slow moving inventory to vendors which increased\r\n         revenue.  Restructured warehouse and introduced RF\r\n         technology to optimize pick/pack operations.\r\n\r\n                             VEECO INSTRUMENTS, INC.,  Plainview, NY -\r\n                             Warehouse Supervisor  (1996 - 2000)\r\n\r\n        Responsible for the supervision and maintenance of all materials,\r\n        and warehouse operations for this\r\n        fast-paced, multi-million dollar manufacturer of computer data\r\n        storage equipment.  Worked closely with\r\n        purchasing, engineering and inspection departments to maintain\r\n        and update inventory REV levels, including all ECO\r\n        changes.  Involved with all phases of material management,\r\n        including MRP, to ensure that expeditions and procurements\r\n        were handled in the most efficient manner.  Coordinated with\r\n        production planning to prioritize all BOM's, projects and\r\n        pick-pack operations for the assembly kits, backorder payouts and\r\n        material requisitions for the production floor.   APICS\r\n        certified and member of ISO9001 team.\r\n\r\n\r\nJEFFREY A. DAVIS                                                     6713\r\nBray Road   Goshen, OH 45122\r\nJeffd1969@aol.com\r\nHm 513-625-7228    Cell 513-679-1446\r\n\r\n\r\nMILITARY EXPERIENCE\r\nUnited States Navy  (1988 - 1992)\r\nRank: E4    Supply / Logistics  POIC\r\nHonorable Discharge, 1992\r\n\r\nEDUCATION\r\nEastern Oklahoma State College, McAlester, OK\r\nMajor:  Business Management (1992 - 1993)\r\n\r\nSuffolk County Community College, Selden, NY\r\nMajor:  Business Management (1994 - 1997)\r\n\r\nREFERENCES\r\nAvailable upon request&lt;/ResumeText&gt;&lt;MilitaryExperience&gt;Veteran&lt;/MilitaryExperience&gt;&lt;WorkHistory&gt;&lt;ExtCompany&gt;&lt;CompanyName&gt;OWENS &amp;amp; MINOR&lt;/CompanyName&gt;&lt;JobTitle&gt;Warehouse Lead Supervisor&lt;/JobTitle&gt;&lt;Tenure&gt;01/01/2008 - Present&lt;/Tenure&gt;&lt;/ExtCompany&gt;&lt;ExtCompany&gt;&lt;CompanyName&gt;THE HOME DEPOT&lt;/CompanyName&gt;&lt;JobTitle&gt;- Sales Specialist&lt;/JobTitle&gt;&lt;Tenure&gt;01/01/2005 - Present&lt;/Tenure&gt;&lt;/ExtCompany&gt;&lt;ExtCompany&gt;&lt;CompanyName&gt;RUBIES COSTUME CO&lt;/CompanyName&gt;&lt;JobTitle&gt;- Warehouse Assistant Manager&lt;/JobTitle&gt;&lt;Tenure&gt;01/01/2004 - 01/01/2006&lt;/Tenure&gt;&lt;/ExtCompany&gt;&lt;ExtCompany&gt;&lt;CompanyName&gt;UNITED ELECTRIC POWER&lt;/CompanyName&gt;&lt;JobTitle&gt;Inventory Operations Manager&lt;/JobTitle&gt;&lt;Tenure&gt;01/01/2000 - 01/01/2004&lt;/Tenure&gt;&lt;/ExtCompany&gt;&lt;ExtCompany&gt;&lt;CompanyName&gt;VEECO INSTRUMENTS, INC&lt;/CompanyName&gt;&lt;JobTitle&gt;Warehouse Supervisor&lt;/JobTitle&gt;&lt;Tenure&gt;01/01/1996 - 01/01/2000&lt;/Tenure&gt;&lt;/ExtCompany&gt;&lt;/WorkHistory&gt;&lt;EducationHistory&gt;&lt;ExtSchool&gt;&lt;SchoolName&gt;Eastern Oklahoma State College&lt;/SchoolName&gt;&lt;Major&gt;Business Management&lt;/Major&gt;&lt;Degree /&gt;&lt;GraduationDate&gt;11993&lt;/GraduationDate&gt;&lt;/ExtSchool&gt;&lt;ExtSchool&gt;&lt;SchoolName&gt;Suffolk County Community College&lt;/SchoolName&gt;&lt;Major&gt;Business Management&lt;/Major&gt;&lt;Degree /&gt;&lt;GraduationDate&gt;11997&lt;/GraduationDate&gt;&lt;/ExtSchool&gt;&lt;/EducationHistory&gt;&lt;Warning&gt;&lt;/Warning&gt;&lt;/Packet&gt;</string>")
        end

        it 'should return a resume result' do
          @resume = @client.get_resume(:resume_id => "RH52G867678F7GH02Q3")
          @resume.should == nil
        end

      end

    end

  end

end
