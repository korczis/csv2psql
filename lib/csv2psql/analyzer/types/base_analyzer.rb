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
          sql_class?(:numeric)
        end

        def sql_class?(class_name)
          const_get('CLASS') == class_name
        end

        def sql_class
          const_get('CLASS')
        end

        def sql_class?(class_name)
          sql_class == class_name
        end

        def sql_type
          const_get('TYPE')
        end

        def sql_type?(type_name)
          sql_type == type_name
        end

        def weight
          const_get('WEIGHT')
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

      def sql_class
        self.class.sql_class
      end

      def sql_class?(class_name)
        self.class.sql_class?(class_name)
      end

      def sql_type
        self.class.sql_type
      end

      def sql_type?(type_name)
        self.class.sql_type?(type_name)
      end

      def weight
        self.class.weight
      end
    end
  end
end
