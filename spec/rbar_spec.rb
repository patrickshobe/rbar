# frozen_string_literal: true

RSpec.describe Rbar do
  let(:output) { ::StringIO.new }
  let(:formatter) { ::Rbar.new(output) }
  let(:example) { self.class.example }

  before do
    allow(::RSpec.configuration).to receive(:color_mode).and_return(:on)
  end

  context "when it is created" do
    it "creates the main progress bar" do
      expect(formatter.progress_bar).to be_instance_of(TTY::ProgressBar::Multi)
    end
  end

  context "when it is started" do
    let(:start_notification) { ::RSpec::Core::Notifications::StartNotification.new(2, ::Time.now) }

    subject(:start_formatter) { formatter.start(start_notification) }

    it "sets the total to the number of examples" do
      start_formatter
      expect(formatter.progress_bar.total).to be(6)
    end

    context "and an example passes" do
      it "increments the success count" do
        start_formatter
        formatter.example_passed(example)

        expect(formatter.pass_count).to eq(1)
      end

      it "increments the success bar" do
        start_formatter
        formatter.example_passed(example)

        expect(formatter.pass_bar.current).to eq(1)
      end
    end

    context "and an example is pending" do
      it "increments the success count" do
        start_formatter
        formatter.example_pending(example)

        expect(formatter.pending_count).to eq(1)
      end

      it "increments the pending bar" do
        start_formatter
        formatter.example_pending(example)

        expect(formatter.pending_bar.current).to eq(1)
      end
    end

    context "and an example fails" do
      it "increments the failure count" do
        start_formatter
        formatter.example_failed(example)

        expect(formatter.failed_count).to eq(1)
      end

      it "increments the failed bar" do
        start_formatter
        formatter.example_failed(example)

        expect(formatter.failed_bar.current).to eq(1)
      end
    end
  end
end
