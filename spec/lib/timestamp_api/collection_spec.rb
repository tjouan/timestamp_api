require "spec_helper"

describe TimestampAPI::Collection do
  it "inherits from Array" do
    expect(TimestampAPI::Collection.new).to be_a Array
  end

  it "can be casted to an Array" do
    expect(Array.new(TimestampAPI::Collection.new).class).to eq Array
  end

  describe "#where(conditions)" do
    let(:projectA1) { double(name: "project1", client: "clientA") }
    let(:projectA2) { double(name: "project2", client: "clientA") }
    let(:projectB1) { double(name: "project1", client: "clientB") }
    let(:collection) { TimestampAPI::Collection.new([projectA1, projectA2, projectB1]) }

    it "selects items on equality of condition key and value" do
      expect(collection.where(name: "project1")).to match_array [projectA1, projectB1]
    end

    it "combines multiple conditions" do
      expect(collection.where(name: "project1", client: "clientA")).to eq [projectA1]
    end

    it "is chainable" do
      expect(collection.where(name: "project1").where(client: "clientA")).to eq [projectA1]
    end

    it "raise an error when argument is not a Hash" do
      expect{ collection.where("not a hash") }.to raise_error TimestampAPI::InvalidWhereContitions
    end
  end
end
