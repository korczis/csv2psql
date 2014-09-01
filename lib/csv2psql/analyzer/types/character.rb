# encoding: UTF-8

module Csv2Psql
  module Analyzers
    class Character
      TYPE = :bigint

      attr_reader :count

      def initialize
        @count = 0
      end

      def analyze(val)
        match = val && val.to_s.length == 1
        return if !match
        @count = @count + 1
      end
    end
  end
end
