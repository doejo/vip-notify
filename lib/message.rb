require "hashr"

class Message
  attr_reader :data

  def initialize(data)
    @data = Hashr.new(data)
  end

  def theme
    data.theme
  end

  def payload
    {
      username:    username,
      icon_url:    icon,
      attachments: [deploy, commits]
    }
  end

  private

  def username
    ENV["SLACK_USER"] || "VIP Deployments"
  end

  def icon
    ENV["SLACK_ICON"] || "https://s.w.org/about/images/logos/wordpress-logo-simplified-rgb.png"
  end

  def deploy
    {
      fallback: "New #{data.theme} deployment by #{data.deployer}",
      fields: [
        { title: "Project", value: data.theme, short: true },
        { title: "Revision", value: data.deployed_revision, short: true },
        { title: "Deployer", value: data.deployer, short: true },
        { title: "Previous Revision", value: data.previous_revision, short: true }
      ]
    }
  end

  def commits
    {
      color: "good",
      pretext: "Commits:",
      text: revision_log
    }
  end

  def revision_log
    data.revision_log.to_s.gsub("* ", "").gsub(" -- ", " - ")
  end
end