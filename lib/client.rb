require "faraday"
require "json"

class Client
  def initialize(webhook)
    @webhook = webhook
  end

  def deliver(payload, channel)
    channel = "##{channel}" unless channel =~ /^[#|@]/
    payload[:channel] = channel
    Faraday.post(@webhook, JSON.dump(payload)).body
  end
end