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
    lines.join("\n").strip
  end
end