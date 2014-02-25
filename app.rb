require "bundler/setup"
require "sinatra"
require "slack-notify"

["SLACK_TEAM", "SLACK_TOKEN", "SLACK_CHANNEL"].each do |var|
  raise "#{var} required" if ENV[var].nil?
end

class VipNotifier < Sinatra::Base
  VERSION = "0.1.2"

  class Message
    attr_reader :params

    def initialize(params)
      @params = params
    end

    def lines
      [
        "------------------------------------------------------------",
        "New VIP deploy for #{params["theme"].upcase}",
        "------------------------------------------------------------",
        "By: #{params["deployer"]}",
        "Revision: #{params["deployed_revision"]}",
        "Previous revision: #{params["previous_revision"]}",
        "Revision log:\n",
        params["revision_log"]
      ]
    end

    def to_s
      lines.join("\n")
    end
  end

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
