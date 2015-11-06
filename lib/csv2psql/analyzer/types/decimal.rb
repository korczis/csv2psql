# encoding: UTF-8

require_relative 'base_analyzer'

module Csv2Psql
  module Analyzers
    # Decimal value matcher
    class Decimal < BaseAnalyzer
      TYPE = :decimal
      CLASS = :numeric
      WEIGHT = 3
      RE = Regexp.new(/^[-+]?[0-9]*[.,]?[0-9]+([eE][-+]?[0-9]+)?$/)

      class << self
        def analyze(val)
          return true if val.is_a?(Float)
          res = val && RE.match(val)
          !res.nil?
        end

        def convert(val)
          val.to_f
        end
      end
    end
  end
end
