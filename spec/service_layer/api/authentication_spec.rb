require 'spec_helper'

describe ServiceLayer::Api::Authentication do
  let(:instance) { klass.new }

  subject { instance }

  context "when included on an object with the right interface" do
    let(:klass) do
      Class.new do
        attr_accessor(:params)

        def error!
        end
      end
    end

    before { klass.include(described_class) }

    it { is_expected.to respond_to :authenticator }
    it { is_expected.to respond_to :active_token? }
    it { is_expected.to respond_to :authenticate! }
    it { is_expected.to respond_to :current_key }
    it { is_expected.to respond_to :no_read_only_keys! }
  end

  context 'otherwise' do
    let(:klass) { Class.new }
    let(:exception) { ServiceLayer::Api::Authentication::InterfaceError }

    it "raises an error" do
      expect { klass.include(described_class) }.to raise_exception(exception)
    end
  end

end
