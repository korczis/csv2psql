# encoding: UTF-8

module Csv2Psql
  module Analyzers
    # Decimal value matcher
    class Decimal
      TYPE = :decimal
      CLASS = :numeric
      WEIGHT = 3
      RE = /[-+]?[0-9]*[.,]?[0-9]+([eE][-+]?[0-9]+)?/

      def analyze(val)
        val.is_a?(Float) || (val && !val.match(RE).nil?)
      end
    end
  end
end
