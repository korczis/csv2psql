# encoding: UTF-8

module Csv2Psql
  module Analyzers
    class Uuid
      TYPE = :uuid

      attr_reader :count

      def initialize
        @count = 0
      end

      def analyze(val)
        match = val && val.match(/[a-f0-9]{8}-[a-f0-9]{4}-4[a-f0-9]{3}-[89aAbB][a-f0-9]{3}-[a-f0-9]{12}/)
        return if match.nil?
        @count = @count + 1
      end
    end
  end
end
