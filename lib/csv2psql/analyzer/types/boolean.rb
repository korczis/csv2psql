# encoding: UTF-8

require_relative 'base_analyzer'

module Csv2Psql
  module Analyzers
    # Bolean value matcher
    class Boolean < BaseAnalyzer
      TYPE = :boolean
      CLASS = :special
      WEIGHT = 5

      BOOLEAN_VALUES = %w(true false 0 1)
      BOOLEAN_VALUES_MAP = {}
      BOOLEAN_VALUES.each do |k|
        BOOLEAN_VALUES_MAP[k] = true
      end

      class << self
        def analyze(val)
          return if val.nil? || val.empty?
          BOOLEAN_VALUES_MAP.key?(val.downcase)
        end

        def convert(val)
          val.to_i
        end
      end
    end
  end
end
