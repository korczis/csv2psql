# encoding: UTF-8

module Csv2Psql
  module Analyzers
    # Bolean value matcher
    class Boolean
      TYPE = :boolean
      CLASS = :boolean
      WEIGHT = 5

      BOOLEAN_VALUES = %w(true false 0 1)
      BOOLEAN_VALUES_MAP = {}
      BOOLEAN_VALUES.each do |k|
        BOOLEAN_VALUES_MAP[k] = true
      end

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
