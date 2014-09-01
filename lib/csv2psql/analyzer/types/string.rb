# encoding: UTF-8

module Csv2Psql
  module Analyzers
    # UUID value matcher
    class String
      TYPE = :string
      CLASS = :character
      WEIGHT = 1

      attr_reader :count, :min, :max

      def initialize
        @count = 0
        @min = nil
        @max = nil
      end

      def analyze(val)
        match = val.is_a?(::String)
        return unless match
        len = val.length
        @min = len if @min.nil? || len < @min
        @max = len if @max.nil? || len > @max
        @count += 1
      end

      def to_h
        {
          count: @count,
          min: @min,
          max: @max
        }
      end
    end
  end
end
