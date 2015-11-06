# encoding: UTF-8

require_relative 'base_analyzer'

module Csv2Psql
  module Analyzers
    # Bolean value matcher
    class Boolean < BaseAnalyzer
      TYPE = :boolean
      CLASS = :special
      WEIGHT = 5

      TRUE_VALUES = [
        true,
        't',
        'true',
        'y',
        'yes',
        'on',
        '1',
      ]
      FALSE_VALUES = [
        false,
        'f',
        'false',
        'n',
        'no',
        'off',
        '0'
      ]
      BOOLEAN_VALUES = TRUE_VALUES + FALSE_VALUES

      class << self
        def analyze(val)
          return false if val.nil? || val.empty?
          BOOLEAN_VALUES.index(val) != nil
        end

        def convert(val)
          val.downcase
        end
      end
    end
  end
end
