# encoding: UTF-8

require_relative 'base_analyzer'

module Csv2Psql
  module Analyzers
    # Null value matcher
    class Null < BaseAnalyzer
      TYPE = :null
      CLASS = :null
      WEIGHT = 0

      class << self
        def analyze(val)
          val.nil? || val.empty?
        end
      end
    end
  end
end
