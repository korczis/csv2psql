# encoding: UTF-8

module Csv2Psql
  module Analyzers
    # UUID value matcher
    class String
      TYPE = :string
      CLASS = :character
      WEIGHT = 1

      def analyze(val)
        val.is_a?(::String)
      end
    end
  end
end
