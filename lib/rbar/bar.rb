# frozen_string_literal: true

require 'rspec/core'
require 'rspec/core/formatters/base_text_formatter'
require 'tty-progressbar'

require_relative '../rbar'
require_relative './bars/passing'
require_relative './bars/pending'
require_relative './bars/failed'

module Rbar
  class Bar < ::RSpec::Core::Formatters::BaseTextFormatter
    ::RSpec::Core::Formatters.register self,
                                       :example_failed,
                                       :example_passed,
                                       :example_pending,
                                       :dump_pending,
                                       :dump_failed,
                                       :dump_summary,
                                       :start

    def start(notification)
      super

      self.total = notification.count
      register_sub_bars
    end

    def example_passed(_notification)
      pass_bar.increment
    end

    def example_pending(_notification)
      pending_bar.increment
    end

    def example_failed(_notification)
      failed_bar.increment
    end

    def progress_bar
      @progress_bar ||= TTY::ProgressBar::Multi.new(width: TTY::Screen.width * 0.75)
    end

    attr_accessor :failed_bar, :pass_bar, :pending_bar

    private

    attr_accessor :total

    def register_sub_bars
      self.pass_bar = Rbar::Bars::Passing.new(parent_bar: progress_bar, total: total)
      self.pending_bar = Rbar::Bars::Pending.new(parent_bar: progress_bar, total: total)
      self.failed_bar = Rbar::Bars::Failed.new(parent_bar: progress_bar, total: total)
    end
  end
end
