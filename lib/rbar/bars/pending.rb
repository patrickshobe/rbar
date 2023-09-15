# frozen_string_literal: true

# # frozen_string_literal: true

require 'pastel'
require_relative './base_bar'

module Rbar
  module Bars
    class Pending < BaseBar
      def color
        Pastel.new.yellow(marker)
      end

      def format
        'Pending [:bar :percent] :current'
      end
    end
  end
end
