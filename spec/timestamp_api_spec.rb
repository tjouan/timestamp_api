require "spec_helper"

describe TimestampAPI do
  it "has a version number" do
    expect(TimestampAPI::VERSION).not_to be nil
  end

  it "has the default API endpoint configured" do
    expect(TimestampAPI.api_endpoint).to eq "https://api.ontimestamp.com/api"
  end

  describe ".api_key" do
    it "sets the API key globally" do
      expect{ TimestampAPI.api_key = "MY_API_KEY" }.to change{ TimestampAPI.api_key }.from(nil).to("MY_API_KEY")
    end
  end

  describe ".request(method, url)" do
    def api_url_for(path); TimestampAPI.api_endpoint + path end

    let(:response) { [].to_json }

    before do
      TimestampAPI.api_key = "MY_API_KEY"
      stub_request(:any, api_url_for("/path")).to_return(body: response)
    end

    subject { TimestampAPI.request(:get, "/path") }

    it "calls the API on the proper endpoint URL" do
      subject
      expect(a_request(:any, api_url_for("/path"))).to have_been_made
    end

    it "calls the API with the proper HTTP verb" do
      subject
      expect(a_request(:get, /.*/)).to have_been_made
    end

    it "calls the API with the API key in headers" do
      subject
      expect(a_request(:any, /.*/).with(headers: {"X-API-Key" => "MY_API_KEY"})).to have_been_made
    end

    it "calls the API for JSON" do
      subject
      expect(a_request(:any, /.*/).with(headers: {"Accept" => "application/json"})).to have_been_made
    end

    it "calls the API with a user agent" do
      subject
      expect(a_request(:any, /.*/).with(headers: {"User-Agent" => "TimestampAPI Ruby gem (https://github.com/alpinelab/timestamp_api)"})).to have_been_made
    end

    context "when server returns HTML instead of JSON" do
      let(:response) { "<html>Some HTML</html>" }

      it "raises a InvalidServerResponse error" do
        expect{ subject }.to raise_error(TimestampAPI::InvalidServerResponse)
      end
    end

    context "when server returns a hash" do
      let(:response) { {foo: "bar", nested: [key: "value"]}.to_json }

      it "returns a RecursiveOpenStruct" do
        data = subject
        expect(data).to be_a RecursiveOpenStruct
        expect(data.foo).to eq "bar"
        expect(data.nested.first.key).to eq "value"
      end
    end

    context "when server returns an array" do
      let(:response) { [{foo: "bar"}, {nested: [key: "value"]}].to_json }

      it "returns an array of RecursiveOpenStruct" do
        data = subject
        expect(data).to all be_a RecursiveOpenStruct
        expect(data.first.foo).to eq "bar"
        expect(data.last.nested.first.key).to eq "value"
      end
    end
  end
end
