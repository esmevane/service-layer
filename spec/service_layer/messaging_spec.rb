require 'spec_helper'

describe ServiceLayer::Messaging do
  let(:klass) do
    klass = Class.new
    klass.include ServiceLayer::Messaging
    klass.new
  end

  let(:message) { "Just about any string" }

  before do
    ServiceLayer.config.feedback = true

    allow(Kernel).to receive(:warn)
    allow(Kernel).to receive(:puts)
    allow(ServiceLayer.logger).to receive(:warn)
    allow(ServiceLayer.logger).to receive(:info)
  end

  after { ServiceLayer.config.feedback = false }

  describe "#info" do
    subject { klass.info(message) }

    it "warns in stderr" do
      expect(Kernel).to receive(:puts)
      subject
    end

    it "logs a warning" do
      expect(ServiceLayer.logger).to receive(:info).with(message)
      subject
    end
  end

  describe "#warning" do
    subject { klass.warning(message) }

    it "warns in stderr" do
      expect(Kernel).to receive(:warn)
      subject
    end

    it "logs a warning" do
      expect(ServiceLayer.logger).to receive(:warn).with(message)
      subject
    end
  end
end
