# encoding: UTF-8

module Csv2Psql
  module Analyzers
    class Null
      TYPE = :null

      attr_reader :count

      def initialize
        @count = 0
      end

      def analyze(val)
        match = val.nil? || val.empty?
        return if !match
        @count = @count + 1
      end
    end
  end
end
