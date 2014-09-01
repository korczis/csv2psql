# encoding: UTF-8

module Csv2Psql
  module Analyzers
    # Character value matcher
    class Character
      TYPE = :bigint

      attr_reader :count

      def initialize
        @count = 0
      end

      def analyze(val)
        match = val && val.to_s.length == 1
        return unless match
        @count += 1
      end
    end
  end
end
