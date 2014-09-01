# encoding: UTF-8

module Csv2Psql
  module Analyzers
    # Bigint value matcher
    class Bigint
      TYPE = :bigint
      CLASS = :numeric
      WEIGHT = 4

      attr_reader :count, :min, :max

      def initialize
        @count = 0
        @min = nil
        @max = nil
      end

      def analyze(val)
        return unless val.is_a?(Integer) || (val && val.match(/^\d+$/))

        update(convert(val))
      end

      def convert(val)
        val.to_i
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
