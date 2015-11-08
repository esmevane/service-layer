require 'spec_helper'

describe ServiceLayer::Api::Authentication::Authenticator do
  let(:api)      { double('api') }
  let(:params)   { double('params', token: token) }
  let(:token)    { SecureRandom.hex }
  let(:strategy) { -> x { true } }

  let(:authenticator) do
    described_class.new(api: api, params: params, strategy: strategy)
  end

  subject { authenticator }

  it { is_expected.to respond_to :active_token? }
  it { is_expected.to respond_to :api }
  it { is_expected.to respond_to :authenticate! }
  it { is_expected.to respond_to :current_key }
  it { is_expected.to respond_to :no_read_only_keys! }
  it { is_expected.to respond_to :params }
  it { is_expected.to respond_to :strategy }
  it { is_expected.to respond_to :token }

  describe '.helper_methods' do
    let(:delegation_interface) do
      %i(
        active_token?
        authenticate!
        current_key
        no_read_only_keys!
      )
    end

    subject { described_class.helper_methods }

    it { is_expected.to eq delegation_interface }
  end

  describe '#active_token?' do
    before do
      allow(authenticator.current_key)
        .to receive(:present?)
        .and_return(presence)
    end

    subject { authenticator.active_token? }

    context 'when there is a current key' do
      let(:presence) { true }
      it { is_expected.to eq true }
    end

    context 'otherwise' do
      let(:presence) { false }
      it { is_expected.to eq false }
    end
  end

  describe '#authenticate!' do
    subject { authenticator.authenticate! }

    context 'when there is no token' do
      let(:bad_request_params) do
        [
          described_class::BAD_REQUEST,
          described_class::BAD_REQUEST.fetch(:code)
        ]
      end

      before { allow(authenticator.token).to receive(:blank?).and_return(true) }

      it "raises a bad request error" do
        expect(api).to receive(:error!).with(*bad_request_params)

        subject
      end
    end

    context 'when there is no active token' do
      let(:inactive_params) do
        [
          described_class::INACTIVE_TOKEN,
          described_class::INACTIVE_TOKEN.fetch(:code)
        ]
      end

      before do
        allow(authenticator)
          .to receive(:active_token?)
          .and_return(false)
      end

      it "raises an inactive error" do
        expect(api).to receive(:error!).with(*inactive_params)

        subject
      end
    end
  end

  describe '#current_key' do
    before { authenticator.instance_variable_set(:@current_key, nil) }

    subject { authenticator.current_key }

    it { is_expected.to eq strategy.call(params.token) }

    it "calls the strategy with the given token" do
      expect(strategy).to receive(:call).with(params.token)

      subject
    end

  end

  describe '#no_read_only_keys!' do
    subject { authenticator.no_read_only_keys! }

    context 'when the current key is a consumer key' do
      let(:unprivileged_params) do
        [
          described_class::UNPRIVILEGED,
          described_class::UNPRIVILEGED.fetch(:code)
        ]
      end

      before do
        allow(authenticator.current_key)
          .to receive(:consumer?)
          .and_return(true)
      end

      it "raises an unprivileged error" do
        expect(api).to receive(:error!).with(*unprivileged_params)

        subject
      end
    end

    context 'when the current key has a no method error' do
      let(:bad_request_params) do
        [
          described_class::BAD_REQUEST,
          described_class::BAD_REQUEST.fetch(:code)
        ]
      end

      before do
        allow(authenticator.current_key)
          .to receive(:consumer?)
          .and_raise(NoMethodError)
      end

      it "raises an bad request error" do
        expect(api).to receive(:error!).with(*bad_request_params)

        subject
      end
    end

    context 'when the current key raises a key error' do
      let(:bad_request_params) do
        [
          described_class::BAD_REQUEST,
          described_class::BAD_REQUEST.fetch(:code)
        ]
      end

      before do
        allow(authenticator.current_key)
          .to receive(:consumer?)
          .and_raise(KeyError)
      end

      it "raises an bad request error" do
        expect(api).to receive(:error!).with(*bad_request_params)

        subject
      end
    end
  end

end
