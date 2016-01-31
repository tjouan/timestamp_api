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
  before { fake_model("Fake") }

  it "defines a custom message containing arguments given" do
    expect(TimestampAPI::InvalidModelData.instance_methods(false)).to include :message
    expect(TimestampAPI::InvalidModelData.new(Fake, {"object" => "fake"}).message).to match /Fake/
    expect(TimestampAPI::InvalidModelData.new(Fake, {"object" => "fake"}).message).to match /fake/
  end

  it "has a different message when argument is not a Hash" do
    expect(TimestampAPI::InvalidModelData.new(Fake, "fake").message).to match /\w+/
    expect(TimestampAPI::InvalidModelData.new(Fake, "fake").message).to_not eq TimestampAPI::InvalidModelData.new(Fake, {"object" => "fake"}).message
  end
end

describe TimestampAPI::UnknownModelData do
  it "defines a custom message containing argument given" do
    expect(TimestampAPI::UnknownModelData.instance_methods(false)).to include :message
    expect(TimestampAPI::UnknownModelData.new("not_a_model").message).to match /not_a_model/
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

describe TimestampAPI::UnknownAssociation do
  before { fake_model("Fake") }

  it "defines a custom message containing arguments given" do
    expect(TimestampAPI::UnknownAssociation.instance_methods(false)).to include :message
    expect(TimestampAPI::UnknownAssociation.new(Fake, "unknown_association").message).to match /Fake/
    expect(TimestampAPI::UnknownAssociation.new(Fake, "unknown_association").message).to match /unknown_association/
  end
end

describe TimestampAPI::ResourceNotFound do
  before { fake_model("Fake") }

  it "defines a custom message containing argument given" do
    expect(TimestampAPI::ResourceNotFound.instance_methods(false)).to include :message
    expect(TimestampAPI::ResourceNotFound.new(Fake, 123).message).to match /Fake/
    expect(TimestampAPI::ResourceNotFound.new(Fake, 123).message).to match /123/
  end
end

describe TimestampAPI::APIPathNotSet do
  before { fake_model("Fake") }

  it "defines a custom message containing argument given" do
    expect(TimestampAPI::APIPathNotSet.instance_methods(false)).to include :message
    expect(TimestampAPI::APIPathNotSet.new(Fake).message).to match /Fake/
  end
end
