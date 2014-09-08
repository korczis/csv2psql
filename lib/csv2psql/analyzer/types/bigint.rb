# encoding: UTF-8

module Csv2Psql
  module Analyzers
    # Bigint value matcher
    class Bigint
      TYPE = :bigint
      CLASS = :numeric
      WEIGHT = 4

      def analyze(val)
        val.is_a?(Integer) || (val && !val.match(/^\d+$/).nil?)
      end

      def convert(val)
        val.to_i
      end
    end
  end
end
