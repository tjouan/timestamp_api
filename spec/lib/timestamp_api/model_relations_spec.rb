require "spec_helper"

describe TimestampAPI::ModelRelations do
  let(:json_data) { {"object" => "fake", "name" => "Georges", "bornAt" => "60 years ago"} }
  let(:client)    { Client.new  "object" => "client",  "id" => "c1" }
  let(:project)   { Project.new "object" => "project", "id" => "p1", "client" => {"id" => client.id} }

  before do
    fake_model("Client")  { has_attributes :id }
    fake_model("Project") { has_attributes :id; belongs_to :client }
    allow(Client).to receive(:find).with(nil).and_return(nil)
    allow(Client).to receive(:find).with(client.id).and_return(client)
  end

  it "provides a getter to the linked item" do
    expect(project.client).to eq client
  end

  it "memoizes the getter result to minimize network requests" do
    2.times { project.client }
    expect(Client).to have_received(:find).with(client.id).once
  end

  context "when it belongs_to something that is not initialized" do
    let(:project) { Project.new("object" => "project", "id" => "p1") }

    it "returns nil" do
      expect(project.client).to be nil
    end
  end

  context "when it belongs_to something which does not exist" do
    let(:project) { Project.new("object" => "project", "id" => "p1", "client" => {"id" => "not_existing"}) }

    before { allow(Client).to receive(:find).with("not_existing").and_raise(TimestampAPI::ResourceNotFound.new(Project, "not_existing")) }

    it "raises a ResourceNotFound error" do
      expect{ project.client }.to raise_error TimestampAPI::ResourceNotFound
    end
  end

  context "when it belongs_to a not registered model" do
    before { fake_model("Project") { has_attributes :id; belongs_to :not_a_model } }

    it "raises a UnknownAssociation error" do
      expect{ project.not_a_model }.to raise_error TimestampAPI::UnknownAssociation
    end
  end
end
