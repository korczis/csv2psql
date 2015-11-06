# encoding: UTF-8

require_relative 'base_analyzer'

module Csv2Psql
  module Analyzers
    # UUID value matcher
    class Uuid < BaseAnalyzer
      TYPE = :uuid
      CLASS = :special
      WEIGHT = 5

      RE = Regexp.new(/^[a-f0-9]{8}-[a-f0-9]{4}-4[a-f0-9]{3}-[89aAbB][a-f0-9]{3}-[a-f0-9]{12}$/) # rubocop:disable Metrics/LineLength

      class << self
        def analyze(val)
          val && val.match(RE)
        end
      end
    end
  end
end
