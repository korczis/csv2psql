# encoding: UTF-8

require_relative 'base_analyzer'

module Csv2Psql
  module Analyzers
    # Bigint value matcher
    class Time < BaseAnalyzer
      TYPE = :time
      CLASS = :date
      WEIGHT = 3

      RE = Regexp.new(/^[0-9]{2}:[0-9]{2}(:[0-9]{2})?$/)

      class << self
        def analyze(val)
          val && RE.match(val)
        end

        def convert(val)
          val.to_i
        end
      end
    end
  end
end
