require "spec_helper"

describe Message do
  let(:params) do
    {
      "theme"             => "app",
      "deployer"          => "John Doe",
      "deployed_revision" => "ABC",
      "previous_revision" => "DEF",
      "revision_log"      => "LOG"
    }
  end

  let(:message) { described_class.new(params) }

  describe "#payload" do
    it "returns formatted hash" do
      expect(message.payload).to eq Hash(
        username: "foobar",
        icon_url: "https://s.w.org/about/images/logos/wordpress-logo-simplified-rgb.png",
        attachments: [
          {
            fallback: "New app deployment by John Doe",
            fields: [
              { title: "Project", value: "app", short: true},
              { title: "Revision", value: "ABC", short: true},
              { title: "Deployer", value: "John Doe", short: true},
              { title: "Previous Revision", value: "DEF", short: true}
            ]
          },
          {
            color: "good",
            pretext: "Commits:",
            text: "LOG"
          }
        ]
      )
    end
  end
end