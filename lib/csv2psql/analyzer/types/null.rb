# encoding: UTF-8

module Csv2Psql
  module Analyzers
    # Null value matcher
    class Null
      TYPE = :null
      CLASS = nil # TODO: Maybe use better class for Null type?
      WEIGHT = 0

      def analyze(val)
        val.nil? || val.empty?
      end
    end
  end
end
