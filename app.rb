require "bundler/setup"
require "sinatra"
require "./lib/client"
require "./lib/message"

["SLACK_WEBHOOK", "SLACK_CHANNEL"].each do |var|
  raise "#{var} required" if ENV[var].nil?
end

class VipNotifier < Sinatra::Base
  VERSION = "0.3.0"

  def client
    @client ||= Client.new(ENV["SLACK_WEBHOOK"])
  end

  def default_channel
    ENV["SLACK_CHANNEL"]
  end

  def parse_mappings
    (ENV["NOTIFICATIONS"] || "").split(";").inject({}) do |hash, grp|
      names, channels = grp.split(":")
      names.split(",").map(&:strip).uniq.each do |n|
        hash[n] = channels.split(",").map(&:strip)
      end
      hash
    end
  end

  def channel_mappings
    @channel_mappings ||= parse_mappings
  end

  def channels_for_project(project)
    channel_mappings[project] || [default_channel] 
  end

  get "/" do
    "VIP Notifier v#{VERSION}"
  end

  get "/test" do
    data = {
      theme: "theme-name",
      deployer: "deployer-name",
      previous_revision: "OLD REV",
      deployed_revision: "NEW REV",
      revision_log: "SAMPLE LOG"
    }

    client.deliver(Message.new(data).payload, default_channel)
    "OK"
  end

  post "/notify" do
    if params.empty?
      halt(400, "Payload required")
    end

    if ENV["DEBUG"]
      STDERR.puts(params.inspect)
    end

    message = Message.new(params)
    payload = message.payload
    
    channels_for_project(message.theme).each do |chan|
      client.deliver(payload, chan)
    end
    
    "OK"
  end
end
