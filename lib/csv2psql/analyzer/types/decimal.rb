# encoding: UTF-8

module Csv2Psql
  module Analyzers
    # Decimal value matcher
    class Decimal
      TYPE = :decimal
      CLASS = :numeric
      WEIGHT = 3

      attr_reader :count, :min, :max

      def initialize
        @count = 0
        @min = nil
        @max = nil
      end

      def analyze(val)
        return unless val.is_a?(Float) || (val && val.match(/(\d+[,.]\d+)/))

        update(convert(val))
      end

      def convert(val)
        val.to_f
      end

      def to_h
        {
          count: @count,
          min: @min,
          max: @max
        }
      end

      def update(val)
        @count += 1
        @min = val if @min.nil? || val < @min
        @max = val if @max.nil? || val > @max
      end
    end
  end
end
