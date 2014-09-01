# encoding: UTF-8

module Csv2Psql
  module Analyzers
    class Bigint
      TYPE = :bigint

      attr_reader :count, :min, :max

      def initialize
        @count = 0
        @min = nil
        @max = nil
      end

      def analyze(val)
        match = val.is_a?(Integer) || (val && val.match(/^\d+$/))
        return if match.nil?

        val = val.to_i
        @count = @count + 1
        @min = val if @min.nil? || val < @min
        @max = val if @max.nil? || val > @max
      end
    end
  end
end
