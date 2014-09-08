# encoding: UTF-8

require 'pathname'
require 'pp'

require_relative '../helpers/erb_helper'
require_relative '../extensions/string'

module Csv2Psql
  # Analyzer file analyzer class
  class Analyzer
    DEFAULT_OPTIONS = {}
    ANALYZERS_DIR = File.join(File.dirname(__FILE__), 'types')

    attr_reader :analyzers, :files

    def initialize(cache = nil)
      @files = {}
      @cache = cache
      @analyzers = load_analyzers
    end

    def analyze(path, row, opts = {})
      data = get_data(path)

      header = CsvHelper.get_header(row, opts)
      analyze_row(header, row, data)

      data[:lines] = data[:lines] + 1
    end

    def analyze_column(analyzer, val, opts = { :use_cache => false })
      # if opts[:use_cache]
      #   res = cached_result(val) do
      #     analyzer[:class].analyze(val)
      #   end
      # else
      #   res = analyzer[:class].analyze(val)
      # end

      res = analyzer[:class].analyze(val)
      update_results(analyzer, res, val) if res
    end

    def analyze_row(header, row, data)
      header.each do |h|
        col = get_column(data, h)
        col.each do |_name, analyzer|
          analyze_column(analyzer, row[h])
        end
      end
    end

    def cached_result(val, &block)
      res = @cache.get(val)
      if res.nil?
        res = block.call(val)
        @cache.put(val, res)
      end
      res
    end

    # Create column analyzers
    def create_column(data, column)
      data[:columns][column] = {}
      res = data[:columns][column]

      analyzers.each do |analyzer|
        analyzer_class = analyzer[:class]
        res[analyzer[:name]] = {
          class: analyzer_class.new,
          results: create_results(analyzer_class)
        }
      end

      res
    end

    def create_data(path)
      files[path] = {
        columns: {
        },
        lines: 0
      }
      files[path]
    end

    def create_results(analyzer_class)
      res = {
        count: 0
      }

      res[:min] = nil if analyzer_class.const_get(:CLASS) == :numeric
      res[:max] = nil if analyzer_class.const_get(:CLASS) == :numeric

      res
    end

    def get_data(path)
      return files[path] if files.key?(path)

      create_data(path)
    end

    def get_column(data, column)
      res = data[:columns][column]
      return res if res

      create_column(data, column)
    end

    def load_analyze_class(analyzer_class)
      Object.const_get('Csv2Psql')
      .const_get('Analyzers')
      .const_get(analyzer_class)
    end

    def load_analyzers
      Dir[ANALYZERS_DIR + '**/*.rb'].map do |path|
        fname = File.basename(path, '.rb')
        analyzer_class = fname.camel_case
        require(path)

        {
          name: analyzer_class,
          class: load_analyze_class(analyzer_class)
        }
      end
    end

    def update_results(analyzer, _res, _val)
      ar = analyzer[:results]
      ar[:count] += 1
    end
  end
end
