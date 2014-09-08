# encoding: UTF-8

module Csv2Psql
  module Analyzers
    # Character value matcher
    class Character
      TYPE = :bigint
      CLASS = :character
      WEIGHT = 2

      def analyze(val)
        val && val.to_s.length == 1
      end
    end
  end
end
