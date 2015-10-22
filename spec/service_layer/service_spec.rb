require 'spec_helper'

# There's a bit of stub wizardry in place here for the #start and #stop methods,
# which ensures that the service does not spin up a WEBrick process or split
# itself off into another daemonized process during testing.  The splitting off
# behavior is stubbed because it produces some surreal behavior with the
# service itself: creating processes that live beyond the tests, which are
# completely untestable and unverifiable for any assertion.
#
describe ServiceLayer::Service do
  let(:service) { described_class.new(options) }
  let(:pidfile) { service.pidfile }
  let(:dir)     { "/tmp" }
  let(:name)    { "service-name" }

  let(:options) do
    { dir: dir, name: name, daemon: { ontop: true } }
  end

  subject { service }

  it { is_expected.to respond_to :daemon }
  it { is_expected.to respond_to :dir }
  it { is_expected.to respond_to :name }
  it { is_expected.to respond_to :pidfile }

  describe '#id' do
    subject { service.id }

    context 'when the pidfile exists' do
      let(:id) { 345 }

      before { File.open(pidfile, "w") { |f| f.puts id } }
      after { FileUtils.rm(pidfile) }

      it { is_expected.to eq id }
    end

    context "when no pidfile exists" do
      it { is_expected.to be nil }
    end
  end

  describe '#running?' do
    subject { service.running? }

    context 'when the pidfile exists' do
      let(:id) { 345 }

      before { File.open(pidfile, "w") { |f| f.puts id } }
      after { FileUtils.rm(pidfile) }

      it { is_expected.to be true }
    end

    context "when no pidfile exists" do
      it { is_expected.to be false }
    end

  end

  describe '#start' do
    subject { service.start }

    before do
      allow(ServiceLayer).to receive(:ensure_connections).and_yield
      allow(Daemons).to receive(:daemonize)
      allow(Rack::Handler::WEBrick).to receive(:run)
    end

    context 'if #running? is true' do
      before { allow(service).to receive(:running?).and_return(true) }

      it "does not attempt to daemonize a new process" do
        expect(Daemons).not_to receive(:daemonize)
        subject
      end

      it "does not attempt to spin up a new service" do
        expect(Rack::Handler::WEBrick).not_to receive(:run)
        subject
      end
    end

    context 'otherwise' do
      before { allow(service).to receive(:running?).and_return(false) }

      it "attempts to daemonize a new process" do
        expect(Daemons).to receive(:daemonize)
        subject
      end

      it "attempts to spin up a new service" do
        expect(Rack::Handler::WEBrick).to receive(:run)
        subject
      end
    end
  end

  describe '#stop' do
    subject { service.stop }

    before do
      allow(Process).to receive(:kill)
      allow(File).to receive(:read).and_return("345")
      allow(FileUtils).to receive(:rm)
    end

    context 'if #running? is true' do
      before { allow(service).to receive(:running?).and_return(true) }

      it "attempts to read a pidfile" do
        expect(File).to receive(:read).with(service.pidfile).and_return("345")
        subject
      end

      it "attempts to kill any processes" do
        expect(Process).to receive(:kill).with("TERM", 345)
        subject
      end

      it "attempts to remove the pidfile" do
        expect(FileUtils).to receive(:rm).with(service.pidfile)
        subject
      end
    end

    context 'otherwise' do
      before { allow(service).to receive(:running?).and_return(false) }

      it "does not attempt to read a pidfile" do
        expect(File).not_to receive(:read)
        subject
      end

      it "does not attempt to kill any processes" do
        expect(Process).not_to receive(:kill)
        subject
      end

      it "does not attempt to remove the pidfile" do
        expect(FileUtils).not_to receive(:rm)
        subject
      end
    end

  end

end
