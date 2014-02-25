require "spec_helper"

describe "Application" do
  describe "GET /" do
    before { get "/" }

    it "renders home page" do
      expect(last_response.body).to eq "VIP Notifier v#{VipNotifier::VERSION}"
    end
  end

  describe "GET /test" do
    before do
      SlackNotify::Client.any_instance.stub(:test)
    end

    it "sends a test message" do
      expect_any_instance_of(SlackNotify::Client).to receive(:test)
      get "/test"
    end

    it "returns OK" do
      get "/test"
      expect(last_response.body).to eq "OK"
    end
  end

  describe "POST /notify" do
    let(:message) { fixture("message.txt") }

    let(:payload) do
      {
        "theme"             => "app",
        "deployer"          => "John Doe",
        "deployed_revision" => "ABC",
        "previous_revision" => "DEF",
        "revision_log"      => "LOG"
      }
    end

    before do
      SlackNotify::Client.any_instance.stub(:notify)
    end

    it "sends a message" do
      expect_any_instance_of(SlackNotify::Client).to receive(:notify).with(message.strip)
      post "/notify", payload
    end

    it "returns OK" do
      post "/notify", payload
      expect(last_response.body).to eq "OK"
    end

    context "when payload is empty" do
      before do
        post "/notify"
      end

      it "responds with 400 bad request" do
        expect(last_response.status).to eq 400
      end

      it "returns an error message" do
        expect(last_response.body).to eq "Payload required"
      end
    end

    context "when payload has multiple revisions" do
      let(:message) { fixture "message_multiline.txt" }

      before do
        payload["revision_log"] = "Line 1\nLine 2\nLine 3"
      end

      it "formats message with multiple lines" do
        expect_any_instance_of(SlackNotify::Client).to receive(:notify).with(message)
        post "/notify", payload
      end
    end

    context "when debug env is set" do
      before do
        ENV["DEBUG"] = "1"
        STDOUT.stub(:puts)

        post "/notify", payload
      end

      it "logs incoming params to stdout" do
        expect(STDOUT).to have_received(:puts).with(payload.inspect)
      end

      after do
        ENV["DEBUG"] = nil
      end
    end
  end
end
