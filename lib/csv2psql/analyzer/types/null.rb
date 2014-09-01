# encoding: UTF-8

module Csv2Psql
  module Analyzers
    # Null value matcher
    class Null
      TYPE = :null

      attr_reader :count

      def initialize
        @count = 0
      end

      def analyze(val)
        match = val.nil? || val.empty?
        return unless match
        @count += 1
      end
    end
  end
end
