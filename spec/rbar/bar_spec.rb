# frozen_string_literal: true

require "rbar/bar"

RSpec.describe Rbar::Bar do
  let(:output) { StringIO.new }
  let(:formatter) { described_class.new(output) }
  let(:example) { self.class.example }

  before do
    allow(RSpec.configuration).to receive(:color_mode).and_return(:on)
  end

  context "when it is created" do
    it "creates the main progress bar" do
      expect(formatter.progress_bar).to be_instance_of(TTY::ProgressBar::Multi)
    end
  end

  context "when it is started" do
    let(:start_notification) { RSpec::Core::Notifications::StartNotification.new(2, Time.now) }

    subject(:start_formatter) { formatter.start(start_notification) }

    it "sets the total to the number of examples" do
      start_formatter
      expect(formatter.progress_bar.total).to be(6)
    end

    context "and an example passes" do
      it "increments the success count" do
        start_formatter
        allow(formatter.pass_bar).to receive(:increment)
        formatter.example_passed(example)

        expect(formatter.pass_bar).to have_received(:increment)
      end
    end

    context "and an example is pending" do
      it "increments the success count" do
        start_formatter
        allow(formatter.pending_bar).to receive(:increment)
        formatter.example_pending(example)

        expect(formatter.pending_bar).to have_received(:increment)
      end
    end

    context "and an example fails" do
      it "increments the failure count" do
        start_formatter
        allow(formatter.failed_bar).to receive(:increment)
        formatter.example_failed(example)

        expect(formatter.failed_bar).to have_received(:increment)
      end
    end
  end
end
