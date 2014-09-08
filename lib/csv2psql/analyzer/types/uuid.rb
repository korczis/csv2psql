# encoding: UTF-8

require_relative 'base_analyzer'

module Csv2Psql
  module Analyzers
    # UUID value matcher
    class Uuid < BaseAnalyzer
      TYPE = :uuid
      CLASS = :uuid
      WEIGHT = 5

      RE = /^[a-f0-9]{8}-[a-f0-9]{4}-4[a-f0-9]{3}-[89aAbB][a-f0-9]{3}-[a-f0-9]{12}$/ # rubocop:disable Metrics/LineLength

      class << self
        def analyze(val)
          match = val && val.match(RE)
          !match.nil?
        end
      end
    end
  end
end
