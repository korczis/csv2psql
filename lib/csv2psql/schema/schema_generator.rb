# encoding: UTF-8

module Csv2Psql
  # Csv2Psql schema generator class
  class SchemaGenerator
    class << self
      def select_analyzers_by_match(analyzers, match)
        null_count = analyzers['Null'][:results][:count]
        analyzers.select do |_k, v|
          v[:results][:count] + null_count == match
        end
      end

      def select_analyzers_class(analyzers, class_name)
        analyzers.select { |_k, v| v[:class].sql_class?(class_name) }
      end

      def select_best(analyzers, lines)
        analyzers = select_analyzers_by_match(analyzers, lines)
        sorted = analyzers.sort do |a, b|
          a[1][:class].weight <=> b[1][:class].weight
        end

        analyzers[sorted.last[0]]
      end

      def generate(analysis, _opts = {})
        res = {}
        analysis[:columns].each do |name, analyzers|
          analyzer = select_best(analyzers, analysis[:lines])
          res[name] = analyzer
        end
        res
      end
    end
  end
end
