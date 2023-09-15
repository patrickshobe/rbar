# frozen_string_literal: true

# # frozen_string_literal: true

require "pastel"
require_relative "./base_bar"

module Rbar
  module Bars
    class Failed < BaseBar
      def color
        Pastel.new.red(marker)
      end

      def format
        "Failed  [:bar :percent] :current"
      end
    end
  end
end
