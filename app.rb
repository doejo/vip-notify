require "bundler/setup"
require "sinatra"
require "slack-notify"

["SLACK_TEAM", "SLACK_TOKEN", "SLACK_CHANNEL"].each do |var|
  raise "#{var} required" if ENV[var].nil?
end

client = SlackNotify::Client.new(ENV["SLACK_TEAM"], ENV["SLACK_TOKEN"], {
  channel: ENV["SLACK_CHANNEL"],
  username: "wp-vip"
})

get "/" do
  "VIP Notifier"
end

get "/test" do
  client.test
  "OK"
end

post "/notify" do
  "OK"
end