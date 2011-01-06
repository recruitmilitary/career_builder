require 'webmock/rspec'

Spec::Runner.configure do |config|
  config.include WebMock::API
end

WebMock.disable_net_connect!
