# frozen_string_literal: true

# # frozen_string_literal: true

require 'pastel'
require_relative './base_bar'

module Rbar
  module Bars
    class Passing < BaseBar
      def color
        Pastel.new.green(marker)
      end

      def format
        'Passed  [:bar :percent] :current/:total'
      end
    end
  end
end
