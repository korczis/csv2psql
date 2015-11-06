# encoding: UTF-8

require_relative 'base_analyzer'

module Csv2Psql
  module Analyzers
    # UUID value matcher
    class String < BaseAnalyzer
      TYPE = :text
      CLASS = :character
      WEIGHT = 1

      class << self
        def analyze(val)
          val.is_a?(::String) && !val.empty?
        end
      end
    end
  end
end
