# encoding: UTF-8

require_relative 'base_analyzer'

module Csv2Psql
  module Analyzers
    # Bigint value matcher
    class Macaddr < BaseAnalyzer
      TYPE = :macaddr
      CLASS = :special
      WEIGHT = 4

      RE = Regexp.new(/^([0-9A-Fa-f]{2}[:-]){5}([0-9A-Fa-f]{2})$/)

      class << self
        def analyze(val)
          val && RE.match(val)
        end
      end
    end
  end
end
