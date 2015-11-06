# encoding: UTF-8

require_relative 'base_analyzer'

module Csv2Psql
  module Analyzers
    # Bigint value matcher
    class Bigint < BaseAnalyzer
      TYPE = :bigint
      CLASS = :numeric
      WEIGHT = 4

      RE = Regexp.new(/^\d+$/)

      class << self
        def analyze(val)
          val.is_a?(Integer) || (val && RE.match(val))
        end

        def convert(val)
          val.to_i
        end
      end
    end
  end
end
