require 'webmock/rspec'

Spec::Runner.configure do |config|
  config.include WebMock
end

WebMock.disable_net_connect!
