# encoding: UTF-8

module Csv2Psql
  # Csv2Psql schema generator class
  class SchemaGenerator
    class << self
      def select_analyzers_by_match(analyzers, match)
        null_count = analyzers['Null'][:results][:count]
        analyzers.select do |_k, v|
          next if _k != 'String' && v[:results][:count] == 0
          v[:results][:count] + null_count == match
        end
      end

      def select_analyzers_class(analyzers, class_name)
        analyzers.select { |_k, v| v[:class].sql_class?(class_name) }
      end

      def select_best(in_analyzers, lines)
        analyzers = select_analyzers_by_match(in_analyzers, lines)

        # matched_analyzers = analyzers.select do |name, analyzer|
        #   analyzer[:results][:count] === lines
        # end

        sorted = analyzers.sort do |a, b|
          a[1][:class].weight <=> b[1][:class].weight
        end

        analyzers[sorted.last[0]]
      end

      def format_result(analysis, lines)
        res = { columns: {} }
        analysis.each do |k, v|
          res[:columns][k] = {
            type: v[:class].sql_type,
            null: v[:results][:count] != lines
          }
        end
        res
      end

      def generate(analysis, _opts = {})
        res = {}
        analysis[:columns].each do |name, analyzers|
          analyzer = select_best(analyzers, analysis[:lines])
          res[name] = analyzer
        end
        format_result(res, analysis[:lines])
      end
    end
  end
end
