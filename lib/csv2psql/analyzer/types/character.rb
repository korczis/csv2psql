# encoding: UTF-8

module Csv2Psql
  module Analyzers
    # Character value matcher
    class Character
      TYPE = :bigint
      CLASS = :character
      WEIGHT = 2

      attr_reader :count

      def initialize
        @count = 0
      end

      def analyze(val)
        match = val && val.to_s.length == 1
        return unless match
        @count += 1
      end

      def to_h
        {
          count: @count
        }
      end
    end
  end
end
