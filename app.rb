require "bundler/setup"
require "sinatra"
require "slack-notify"

["SLACK_TEAM", "SLACK_TOKEN", "SLACK_CHANNEL"].each do |var|
  raise "#{var} required" if ENV[var].nil?
end

class VipNotifier < Sinatra::Base
  def client
    @client ||= SlackNotify::Client.new(ENV["SLACK_TEAM"], ENV["SLACK_TOKEN"], {
      channel: ENV["SLACK_CHANNEL"],
      username: ENV["SLACK_USER"] || "wp-vip"
    })
  end

  get "/" do
    "VIP Notifier"
  end

  get "/test" do
    client.test
    "OK"
  end

  post "/notify" do
    if params.empty?
      halt(400, "Payload required")
    end

    message = [
      "------------------------------------------------------------",
      "New VIP deploy for #{params["theme"].upcase}",
      "------------------------------------------------------------",
      "By: #{params["deployer"]}",
      "Revision: #{params["deployed_revision"]}",
      "Previous revision: #{params["previous_revision"]}"
    ]

    client.notify(message.join("\n"))
    "OK"
  end
end