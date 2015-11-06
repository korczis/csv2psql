# encoding: UTF-8

require_relative 'base_analyzer'

module Csv2Psql
  module Analyzers
    # Bigint value matcher
    class Cidr < BaseAnalyzer
      TYPE = :cidr
      CLASS = :special
      WEIGHT = 4

      RE = Regexp.new(/^(([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])\.){3}([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])(\/([0-9]|[1-2][0-9]|3[0-2]))$/)

      class << self
        def analyze(val)
          val && RE.match(val)
        end
      end
    end
  end
end
