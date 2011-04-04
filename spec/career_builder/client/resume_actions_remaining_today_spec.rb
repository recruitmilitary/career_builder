require 'spec_helper'

describe CareerBuilder::Client do

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
