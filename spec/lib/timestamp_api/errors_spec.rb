require "spec_helper"

describe TimestampAPI::MissingAPIKey do
  it "defines a custom message" do
    expect(TimestampAPI::MissingAPIKey.instance_methods(false)).to include :message
    expect(TimestampAPI::MissingAPIKey.new.message).to match /\w+/
  end
end

describe TimestampAPI::InvalidAPIKey do
  it "defines a custom message" do
    expect(TimestampAPI::InvalidAPIKey.instance_methods(false)).to include :message
    expect(TimestampAPI::InvalidAPIKey.new.message).to match /\w+/
  end
end

describe TimestampAPI::InvalidServerResponse do
  it "defines a custom message" do
    expect(TimestampAPI::InvalidServerResponse.instance_methods(false)).to include :message
    expect(TimestampAPI::InvalidServerResponse.new.message).to match /\w+/
  end
end

describe TimestampAPI::InvalidModelData do
  it "defines a custom message containing arguments passed" do
    expect(TimestampAPI::InvalidModelData.instance_methods(false)).to include :message
    expect(TimestampAPI::InvalidModelData.new(Array, {"object" => "hash"}).message).to match /Array/
    expect(TimestampAPI::InvalidModelData.new(Array, {"object" => "hash"}).message).to match /hash/
  end

  it "has a different message when argument is not a Hash" do
    expect(TimestampAPI::InvalidModelData.new(Array, "hash").message).to match /\w+/
    expect(TimestampAPI::InvalidModelData.new(Array, "hash").message).to_not eq TimestampAPI::InvalidModelData.new(Array, {"object" => "hash"}).message
  end
end

describe TimestampAPI::UnknownModelData do
  it "defines a custom message containing argument passed" do
    expect(TimestampAPI::UnknownModelData.instance_methods(false)).to include :message
    expect(TimestampAPI::UnknownModelData.new("array").message).to match /array/
  end

  it "has a special message when argument is nil" do
    expect(TimestampAPI::UnknownModelData.new.message).to match /\w+/
    expect(TimestampAPI::UnknownModelData.new.message).to_not eq TimestampAPI::UnknownModelData.new("").message
  end
end

describe TimestampAPI::InvalidWhereContitions do
  it "defines a custom message" do
    expect(TimestampAPI::InvalidWhereContitions.instance_methods(false)).to include :message
    expect(TimestampAPI::InvalidWhereContitions.new.message).to match /\w+/
  end
end
