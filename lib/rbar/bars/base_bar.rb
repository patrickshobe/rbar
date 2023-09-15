# frozen_string_literal: true

require 'tty-progressbar'

module Rbar
  module Bars
    class BaseBar
      def initialize(parent_bar:, total:, count: 0)
        @total = total
        @parent_bar = parent_bar
        @count = count
        @progress_bar = register_self
      end

      def increment
        increment_count
        increment_bar
      end

      def register_self
        bar = parent_bar.register(format,
                                  bar_format: :square,
                                  total: total,
                                  count: '0',
                                  width: TTY::Screen.width * 0.75,
                                  complete: color)
        bar.start
        bar
      end

      def progress
        progress_bar.current
      end

      attr_reader :parent_bar, :count, :total, :progress_bar

      private

      def increment_count
        @count += 1
      end

      def increment_bar
        progress_bar.advance(1, count: (count + 1).to_s)
      end

      def marker
        TTY::ProgressBar::Formats::FORMATS[:square][:complete]
      end

      def color
        marker
      end

      def format
        '[:bar :percent]'
      end
    end
  end
end
