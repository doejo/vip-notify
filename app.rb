require "bundler/setup"
require "sinatra"
require "slack-notify"
require "./lib/message"

["SLACK_WEBHOOK", "SLACK_CHANNEL"].each do |var|
  raise "#{var} required" if ENV[var].nil?
end

class VipNotifier < Sinatra::Base
  VERSION = "0.2.0"

  def client
    @client ||= SlackNotify::Client.new(
      webhook_url: ENV["SLACK_WEBHOOK"],
      channel:     ENV["SLACK_CHANNEL"],
      username:    ENV["SLACK_USER"] || "wp-vip",
      icon_url:    "https://s.w.org/about/images/logos/wordpress-logo-simplified-rgb.png"
    )
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
