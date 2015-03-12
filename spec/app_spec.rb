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
      stub_request(:post, "http://slackhook/").
         with(:body => {"{\"username\":\"foobar\",\"icon_url\":\"https://s.w.org/about/images/logos/wordpress-logo-simplified-rgb.png\",\"attachments\":"=>{"{\"fallback\":\"New theme-name deployment by deployer-name\",\"fields\":"=>{"{\"title\":\"Project\",\"value\":\"theme-name\",\"short\":true},{\"title\":\"Revision\",\"value\":\"NEW REV\",\"short\":true},{\"title\":\"Deployer\",\"value\":\"deployer-name\",\"short\":true},{\"title\":\"Previous Revision\",\"value\":\"OLD REV\",\"short\":true}"=>{"},{\"color\":\"good\",\"pretext\":\"Commits:\",\"text\":\"SAMPLE LOG\"}"=>{",\"channel\":\"#foobar\"}"=>true}}}}},
              :headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Content-Type'=>'application/x-www-form-urlencoded', 'User-Agent'=>'Faraday v0.9.1'}).
         to_return(:status => 200, :body => "", :headers => {})
    end

    it "responds with OK" do
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

    context "with valid payload" do
      before do
        stub_request(:post, "http://slackhook/").
         with(:body => {"{\"username\":\"foobar\",\"icon_url\":\"https://s.w.org/about/images/logos/wordpress-logo-simplified-rgb.png\",\"attachments\":"=>{"{\"fallback\":\"New app deployment by John Doe\",\"fields\":"=>{"{\"title\":\"Project\",\"value\":\"app\",\"short\":true},{\"title\":\"Revision\",\"value\":\"ABC\",\"short\":true},{\"title\":\"Deployer\",\"value\":\"John Doe\",\"short\":true},{\"title\":\"Previous Revision\",\"value\":\"DEF\",\"short\":true}"=>{"},{\"color\":\"good\",\"pretext\":\"Commits:\",\"text\":\"LOG\"}"=>{",\"channel\":\"#foobar\"}"=>true}}}}},
              :headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Content-Type'=>'application/x-www-form-urlencoded', 'User-Agent'=>'Faraday v0.9.1'}).
         to_return(:status => 200, :body => "", :headers => {})
      end

      it "responds with OK" do
        post "/notify", payload
        expect(last_response.body).to eq "OK"
      end
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

    context "when debug env is set" do
      before do
        stub_request(:post, "http://slackhook/").
         with(:body => {"{\"username\":\"foobar\",\"icon_url\":\"https://s.w.org/about/images/logos/wordpress-logo-simplified-rgb.png\",\"attachments\":"=>{"{\"fallback\":\"New app deployment by John Doe\",\"fields\":"=>{"{\"title\":\"Project\",\"value\":\"app\",\"short\":true},{\"title\":\"Revision\",\"value\":\"ABC\",\"short\":true},{\"title\":\"Deployer\",\"value\":\"John Doe\",\"short\":true},{\"title\":\"Previous Revision\",\"value\":\"DEF\",\"short\":true}"=>{"},{\"color\":\"good\",\"pretext\":\"Commits:\",\"text\":\"LOG\"}"=>{",\"channel\":\"#foobar\"}"=>true}}}}},
              :headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Content-Type'=>'application/x-www-form-urlencoded', 'User-Agent'=>'Faraday v0.9.1'}).
         to_return(:status => 200, :body => "", :headers => {})
      end

      before do
        ENV["DEBUG"] = "1"
        STDERR.stub(:puts)

        post "/notify", payload
      end

      it "logs incoming params to stderr" do
        expect(STDERR).to have_received(:puts).with(payload.inspect)
      end

      after do
        ENV["DEBUG"] = nil
      end
    end
  end
end
