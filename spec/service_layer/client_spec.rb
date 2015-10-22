require 'ostruct'
require 'spec_helper'

describe ServiceLayer::Client do
  let(:client) { described_class.new }

  describe '#connection' do
    subject { client.connection }
    it { is_expected.to be_instance_of Faraday::Connection }
  end

  describe '#index' do
    subject { client.index }

    let(:response_body) do
      { data: [] }
    end

    let(:response) { OpenStruct.new(body: response_body.to_json) }

    before do
      allow(client.connection).to receive(:get).and_return(response)
    end

    it "calls #connection.get with the base events path" do
      expect(client.connection)
        .to receive(:get)

      subject
    end

    it "parses the json response" do
      expect(JSON)
        .to receive(:parse)
        .with(response_body.to_json, symbolize_names: true)

      subject
    end
  end
  
end
