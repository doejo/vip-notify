ENV["RACK_ENV"] = "test"

# Initialize fake slack environment vars
ENV["SLACK_TEAM"]    = "foobar"
ENV["SLACK_TOKEN"]   = "foobar"
ENV["SLACK_CHANNEL"] = "foobar"
ENV["SLACK_USER"]    = "foobar"

require "simplecov"
SimpleCov.start

require "sinatra"
require "rack/test"
require "./app"

RSpec.configure do |config|
  config.include Rack::Test::Methods
end

def fixture_path
  File.expand_path("../fixtures", __FILE__)
end

def fixture(file)
  File.read(File.join(fixture_path, file))
end

def app
  VipNotifier
end