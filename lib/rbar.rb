# frozen_string_literal: true

require "rspec/core"
require "rspec/core/formatters/base_text_formatter"
require "tty-progressbar"
require "pastel"

class Rbar < ::RSpec::Core::Formatters::BaseTextFormatter
  ::RSpec::Core::Formatters.register self,
    :example_failed,
    :example_passed,
    :example_pending,
    :dump_pending,
    :dump_failed,
    :dump_summary,
    :start,
    :stop

  def initialize(*args)
    super
  end

  def start(notification)
    super

    self.total = notification.count
    self.failed_count = 0
    self.pending_count = 0
    self.pass_count = 0
    register_sub_bars
    initialize_bars
  end

  def stop(notification)
  end

  def example_passed(_notification)
    self.pass_count += 1
    pass_bar.advance(1, count: (pass_count + 1).to_s)
  end

  def example_pending(_notification)
    self.pending_count += 1
    pending_bar.advance(1, count: (pending_count + 1).to_s)
  end

  def example_failed(_notification)
    self.failed_count += 1
    failed_bar.advance(1, count: (failed_count + 1).to_s)
  end

  def progress_bar
    @progress_bar ||= TTY::ProgressBar::Multi.new(
      width: 40
    )
  end

  attr_accessor :pass_count, :pending_count, :failed_count, :pending_bar, :failed_bar, :pass_bar

  private

  attr_accessor :total

  def register_sub_bars
    self.pass_bar = progress_bar.register("Passed  [:bar :percent] :count/:total",
      bar_format: :square,
      total: total,
      count: "0",
      width: 40,
      complete: green)
    self.pending_bar = progress_bar.register("Pending [:bar :percent] :count",
      bar_format: :square,
      total: total,
      count: "0",
      width: 40,
      complete: yellow)
    self.failed_bar = progress_bar.register("Failed  [:bar :percent] :count",
      bar_format: :square,
      total: total,
      count: "0",
      width: 40,
      complete: red)
  end

  def initialize_bars
    pass_bar.advance(count: "0")
    pass_bar.current = 0
    pending_bar.advance(count: "0")
    pending_bar.current = 0
    failed_bar.advance(count: "0")
    failed_bar.current = 0
  end

  def marker
    TTY::ProgressBar::Formats::FORMATS[:square][:complete]
  end

  def green
    pastel.green(marker)
  end

  def red
    pastel.red(marker)
  end

  def yellow
    pastel.yellow(marker)
  end

  def pastel
    @pastel ||= Pastel.new
  end
end
