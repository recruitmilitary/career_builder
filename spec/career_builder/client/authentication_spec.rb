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

end
