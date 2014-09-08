# encoding: UTF-8

require_relative 'base_analyzer'

module Csv2Psql
  module Analyzers
    # BaseAnalyzer value matcher
    class BaseAnalyzer
      class << self
        def analyze(_val)
          nil
        end

        def convert(val)
          val
        end

        def numeric?
          const_get('CLASS') == :numeric
        end
      end

      def analyze(val)
        self.class.analyze(val)
      end

      def convert(val)
        self.class.convert(val)
      end

      def numeric?
        self.class.numeric?
      end
    end
  end
end
