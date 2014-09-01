# encoding: UTF-8

module Csv2Psql
  module Analyzers
    class Decimal
      TYPE = :decimal

      attr_reader :count, :min, :max

      def initialize
        @count = 0
        @min = nil
        @max = nil
      end

      def analyze(val)
        match = val.is_a?(Float) || (val && val.match(/(\d+[,.]\d+)/))
        return if match.nil?

        val = val.to_f
        @count = @count + 1
        @min = val if @min.nil? || val < @min
        @max = val if @max.nil? || val > @max
      end
    end
  end
end
