# encoding: UTF-8

module Csv2Psql
  module Analyzers
    # Null value matcher
    class Null
      TYPE = :null
      CLASS = nil # TODO: Maybe use better class for Null type?
      WEIGHT = 0

      attr_reader :count

      def initialize
        @count = 0
      end

      def analyze(val)
        match = val.nil? || val.empty?
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
