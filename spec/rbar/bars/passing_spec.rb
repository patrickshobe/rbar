# frozen_string_literal: true

require "rbar/bars/passing"

RSpec.describe Rbar::Bars::Passing do
  let(:main_bar) { TTY::ProgressBar::Multi.new }

  subject(:passing_bar) { described_class.new(parent_bar: main_bar, total: 10) }

  context "when it is created" do
    it "has a count of 0" do
      expect(passing_bar.count).to eq(0)
    end

    it "has a bar progress of zero" do
      expect(passing_bar.progress).to eq(0)
    end
  end

  context "when it is incremented" do
    subject(:increment) { passing_bar.increment }

    it "increments the count" do
      increment

      expect(passing_bar.count).to eq(1)
    end

    it "increments the bar" do
      increment

      expect(passing_bar.progress).to eq(1)
    end
  end

  context "color" do
    it "is green" do
      green_marker = Pastel.new.green(TTY::ProgressBar::Formats::FORMATS[:square][:complete])
      expect(passing_bar.color).to eq(green_marker)
    end
  end

  context "format" do
    it "is the expected length" do
      expect(passing_bar.format.length).to eq(39)
    end

    it "describes what it is" do
      expect(passing_bar.format).to include("Passed")
    end

    it "includes the bar" do
      expect(passing_bar.format).to include(":bar")
    end

    it "includes the total" do
      expect(passing_bar.format).to include(":total")
    end

    it "includes the current" do
      expect(passing_bar.format).to include(":current")
    end

    it "includes the percent" do
      expect(passing_bar.format).to include(":percent")
    end
  end
end
