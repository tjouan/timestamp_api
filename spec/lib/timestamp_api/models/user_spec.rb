require "spec_helper"

describe TimestampAPI::User do
  it "inherits from Model" do
    expect(TimestampAPI::User.superclass).to be TimestampAPI::Model
  end

  it "has `/users` as api_path" do
    expect(TimestampAPI::User.api_path).to eq "/users"
  end

  describe "#full_name" do
    let(:json_data) { {"object" => "user", "firstName" => "Georges", "lastName" => "Abitbol"} }

    subject { TimestampAPI::User.new(json_data).full_name }

    it "returns a concatenation of first name and last name" do
      expect(subject).to eq "Georges Abitbol"
    end
  end
end
