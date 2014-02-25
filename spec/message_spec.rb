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

  describe "#initialize" do
    it "sets params" do
      expect(message.params).to eq params
    end
  end

  describe "#to_s" do
    it "formats a message" do
      expect(message.to_s).to eq fixture("message.txt")
    end

    context "with multiple revisions" do
      before do
        params["revision_log"] = "Line 1\nLine 2\nLine 3"
      end

      it "formats a message with multiple revision" do
        expect(message.to_s).to eq fixture("message_multiline.txt")
      end
    end
  end
end