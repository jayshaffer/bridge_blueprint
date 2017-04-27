require 'bridge_blueprint'
require 'rspec'
require 'webmock/rspec'
require 'json'
require 'pry'

RSpec.configure do |config|
  Dir["./spec/support/**/*.rb"].sort.each {|f| require f}

  config.before(:each) do
    WebMock.disable_net_connect!
    WebMock.stub_request(:any, /api\/.*/).to_rack(FakeBridge)
  end
end


def fixture(*file)
  File.new(File.join(File.expand_path("../fixtures", __FILE__), *file))
end
