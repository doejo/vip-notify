require "bundler/setup"
require "sinatra"
require "slack-notify"
require "./lib/message"

["SLACK_TEAM", "SLACK_TOKEN", "SLACK_CHANNEL"].each do |var|
  raise "#{var} required" if ENV[var].nil?
end

class VipNotifier < Sinatra::Base
  VERSION = "0.1.3"

  def client
    @client ||= SlackNotify::Client.new(ENV["SLACK_TEAM"], ENV["SLACK_TOKEN"], {
      channel: ENV["SLACK_CHANNEL"],
      username: ENV["SLACK_USER"] || "wp-vip"
    })
  end

  get "/" do
    "VIP Notifier v#{VERSION}"
  end

  get "/test" do
    client.test
    "OK"
  end

  post "/notify" do
    if params.empty?
      halt(400, "Payload required")
    end

    # Log request to stdout if debugging is enabled
    if ENV["DEBUG"]
      STDOUT.puts(params.inspect)
    end

    # Send message to Slack channel
    client.notify(Message.new(params).to_s)
    "OK"
  end
end
