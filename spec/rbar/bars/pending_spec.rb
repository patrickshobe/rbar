# frozen_string_literal: true

require 'rbar/bars/pending'

RSpec.describe Rbar::Bars::Pending do
  let(:main_bar) { TTY::ProgressBar::Multi.new }

  subject(:pending_bar) { described_class.new(parent_bar: main_bar, total: 10) }

  context 'when it is created' do
    it 'has a count of 0' do
      expect(pending_bar.count).to eq(0)
    end

    it 'has a bar progress of zero' do
      expect(pending_bar.progress).to eq(0)
    end
  end

  context 'when it is incremented' do
    subject(:increment) { pending_bar.increment }

    it 'increments the count' do
      increment

      expect(pending_bar.count).to eq(1)
    end

    it 'increments the bar' do
      increment

      expect(pending_bar.progress).to eq(1)
    end
  end

  context 'color' do
    it 'is yellow' do
      yellow_marker = Pastel.new.yellow(TTY::ProgressBar::Formats::FORMATS[:square][:complete])
      expect(pending_bar.color).to eq(yellow_marker)
    end
  end

  context 'format' do
    it 'is the expected length' do
      expect(pending_bar.format.length).to eq(32)
    end

    it 'describes what it is' do
      expect(pending_bar.format).to include('Pending')
    end

    it 'includes the bar' do
      expect(pending_bar.format).to include(':bar')
    end

    it 'includes the current' do
      expect(pending_bar.format).to include(':current')
    end

    it 'includes the percent' do
      expect(pending_bar.format).to include(':percent')
    end
  end
end
