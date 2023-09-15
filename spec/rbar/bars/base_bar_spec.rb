# frozen_string_literal: true

require "rbar/bars/base_bar"

RSpec.describe Rbar::Bars::BaseBar do
  let(:main_bar) { TTY::ProgressBar::Multi.new }

  subject(:progress_bar) { described_class.new(parent_bar: main_bar, total: 10) }

  context "when it is created" do
    it "has a count of 0" do
      expect(progress_bar.count).to eq(0)
    end

    it "has a bar progress of zero" do
      expect(progress_bar.progress).to eq(0)
    end

    it "starts the progress_bar" do
      progress_bar_double = instance_double(TTY::ProgressBar, start: true)
      allow(main_bar).to receive(:register).and_return(progress_bar_double)

      progress_bar
      expect(progress_bar_double).to have_received(:start)
    end
  end

  context "when it is incremented" do
    subject(:increment) { progress_bar.increment }

    it "increments the count" do
      increment

      expect(progress_bar.count).to eq(1)
    end

    it "increments the bar" do
      increment

      expect(progress_bar.progress).to eq(1)
    end
  end
end
