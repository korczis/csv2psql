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

      attr_reader :count

      def initialize
        @count = 0
      end

      def analyze(val)
        return if val.nil? || val.empty?
        return unless BOOLEAN_VALUES_MAP.key?(val.downcase)
        @count += 1
      end

      def convert(val)
        val.to_i
      end

      def to_h
        {
          count: @count
        }
      end
    end
  end
end
