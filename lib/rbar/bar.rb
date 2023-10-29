# frozen_string_literal: true

require 'rspec/core'
require 'rspec/core/formatters/base_text_formatter'
require 'tty-progressbar'
require 'tty-table'
require 'tty-tree'
require 'tty-box'
require 'debug'

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
                                       :dump_failures,
                                       :dump_summary,
                                       :start,
                                       :stop

    def start(notification)
      super

      self.total = notification.count
      puts
      register_sub_bars
    end

    def example_passed(_notification)
      pass_bar.increment
      print @string
    end

    def example_pending(_notification)
      pending_bar.increment
      print @string
    end

    def example_failed(_notification)
      failed_bar.increment
      print @string
    end

    def dump_failures(notifi)
      @failed = notifi.fully_formatted_failed_examples
    end

    def dump_pending(_notifi); end

    def print_pending(pending_examples)
      pending = pending_examples.group_by { |pending| pending.example_group.description }

      formatted_pending = pending.transform_values do |group_pending|
        group_pending.map do |example|
          { example.description =>
          example.execution_result.pending_message }
        end
      end

      tree = TTY::Tree.new(formatted_pending)
    end

    def print_failures(failed_examples)
      failures = failed_examples.group_by { |failure| failure.example.example_group.description }

      formatted_failures = failures.transform_values do |group_failures|
        group_failures.map do |failure|
          { failure.description =>
            failure.message_lines.map(&:strip) }
        end
      end

      TTY::Tree.new(formatted_failures)
    end

    def seed(notifi)
      @seed = notifi.seed
    end

    def width
      TTY::Screen.width * 0.75
    end

    def dump_summary(notifi)
      box = TTY::Box.frame(title: { top_left: " Seed #{@seed}" }, width: TTY::Screen.width, padding: 1) do
        string = @failed
        string << print_summary(notifi)
      end
      puts
      puts
      puts box
    end

    def print_summary(notifi)
      table = TTY::Table.new(orientation: :horizontal, padding: 2) do |t|
        t << ['Examples', notifi.example_count]
        t << ['Failed', notifi.failure_count]
        t << ['Pending', notifi.pending_count]
      end

      table.render(:unicode, width: TTY::Screen.width) do |renderer|
        renderer.border.style = result_color
        renderer.border.separator = :each_row
        renderer.padding = 1
        renderer.render
      end
    end

    def result_color
      return :red if failed_bar.progress > 0
      return :yellow if pending_bar.progress > 0

      :green
    end

    def stop(notifi)
      @failure_notifications = notifi.failure_notifications
    end

    def progress_bar
      @progress_bar ||= TTY::ProgressBar::Multi.new(width: width, clear: true)
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
