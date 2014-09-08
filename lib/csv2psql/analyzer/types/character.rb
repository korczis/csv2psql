# encoding: UTF-8

require_relative 'base_analyzer'

module Csv2Psql
  module Analyzers
    # Character value matcher
    class Character < BaseAnalyzer
      TYPE = :bigint
      CLASS = :character
      WEIGHT = 2

      class << self
        def analyze(val)
          val && val.to_s.length == 1
        end
      end
    end
  end
end
