# frozen_string_literal: true

require "rbar/bars/failed"
require "pastel"

RSpec.describe Rbar::Bars::Failed do
  let(:main_bar) { TTY::ProgressBar::Multi.new }

  subject(:failed_bar) { described_class.new(parent_bar: main_bar, total: 10) }

  context "when it is created" do
    it "has a count of 0" do
      expect(failed_bar.count).to eq(0)
    end

    it "has a bar progress of zero" do
      expect(failed_bar.progress).to eq(0)
    end
  end

  context "when it is incremented" do
    subject(:increment) { failed_bar.increment }

    it "increments the count" do
      increment

      expect(failed_bar.count).to eq(1)
    end

    it "increments the bar" do
      increment

      expect(failed_bar.progress).to eq(1)
    end
  end

  context "color" do
    it "is red" do
      red_marker = Pastel.new.red(TTY::ProgressBar::Formats::FORMATS[:square][:complete])
      expect(failed_bar.color).to eq(red_marker)
    end
  end

  context "format" do
    it "is the expected length" do
      expect(failed_bar.format.length).to eq(32)
    end

    it "describes what it is" do
      expect(failed_bar.format).to include("Failed")
    end

    it "includes the bar" do
      expect(failed_bar.format).to include(":bar")
    end

    it "includes the current" do
      expect(failed_bar.format).to include(":current")
    end

    it "includes the percent" do
      expect(failed_bar.format).to include(":percent")
    end
  end
end
